library(ggmap)
library(ggplot2)
library(pbapply)
library(plyr)
library(stringr)
library(XML)

rm(list = ls())

if(file.exists("cities.Rdata")) {

    load("cities.Rdata")

} else {

    url <- "http://academic.udayton.edu/kissock/http/Weather/citylistUS.htm"
    doc <- readLines(url)

    hp <- htmlParse(doc, asText = TRUE)

    files <- str_trim(xpathSApply(hp, "//li//a", xmlValue))

    cities <- xpathSApply(hp, "//li", xmlValue)
    locations <- str_locate(cities, "\\(")
    cities <- str_sub(cities, start = 1, end = locations[, 1] - 1)
    cities <- str_replace(cities, "\\n", "")
    cities <- str_trim(cities)
    cities <- gsub("^ *|(?<= ) | *$", "", cities, perl = TRUE)

    states <- str_sub(files, start = 1, end = 2)
    cities <- paste(cities, ", ", states, sep = "")

    coords <- ldply(lapply(cities, geocode, output = "latlona"), data.frame)

    cities <- data.frame(file = files, address = coords$address,
        lon = coords$lon, lat = coords$lat)

    save(cities, file = "cities.Rdata")

}

if(file.exists("data.Rdata")) {

    load("data.Rdata")

} else {

    baseurl <- "http://academic.udayton.edu/kissock/http/Weather/gsod95-current/"
    urls <- paste(baseurl, cities$file, sep = "")

    col.names <- c("month", "day", "year", "temp")

    data <- pblapply(urls, read.table, col.names = col.names, na.strings = c("-99"))

    save(data, file = "data.Rdata")

}

meandiff <- function(df) {
    mean(abs(diff(df$temp)), na.rm = TRUE)
}

md <- sapply(data, meandiff)

legend.title <- "Avg Daily\nTemp Swing"

p <- qmap("united states", zoom = 3, maptype = "roadmap", legend = "bottomleft",
    color = "bw")
p <- p + geom_point(aes(x = lon, y = lat, size = md, color = md), data = cities,
    alpha = I(0.75))
p <- p + scale_size(name = legend.title)
p <- p + scale_color_gradient(name = legend.title, low = "green", high = "red")
p <- p + guides(color = guide_legend())

print(p)

ggsave("temperature-swings-web.png", p, dpi = 100, width = 5, height = 5)
ggsave("temperature-swings.png", p, dpi = 300, width = 5, height = 5)
