# Code written by Samuel Burer (samuel-burer@uiowa.edu) on 2015.05.10.
# Please provide credit if you use this code in any way.

# Load libraries

library(ggmap)
library(ggplot2)
library(pbapply)
library(plyr)
library(stringr)
library(XML)

# Clear workspace

rm(list = ls())

# The following if-else logic stores and loads downloaded data to speed
# up multiple runs

if(file.exists("cities.Rdata")) {

    load("cities.Rdata")

} else {

    # Download and parse webpage with listing of locations/cities

    url <- "http://academic.udayton.edu/kissock/http/Weather/citylistUS.htm"
    hp <- htmlParse(readLines(url), asText = TRUE)

    # Capture filenames for cities

    files <- str_trim(xpathSApply(hp, "//li//a", xmlValue))

    # Capture city names. Must clean up

    cities <- xpathSApply(hp, "//li", xmlValue)

    # Find index of first opening paranthesis.
    # Extract everything up until first opening paranthesis.
    # Remove any \n characters.
    # Trim leading and trailing white space.
    # Reduce multiple spaces to just one space

    ind <- str_locate(cities, "\\(")
    cities <- str_sub(cities, start = 1, end = ind[, 1] - 1)
    cities <- str_replace(cities, "\\n", "")
    cities <- str_trim(cities)
    cities <- gsub("^ *|(?<= ) | *$", "", cities, perl = TRUE)

    # Finalize city addresses by pasting with two-letter state codes
    # from filenames. We are using the filename convention of the
    # website

    states <- str_sub(files, start = 1, end = 2)
    cities <- paste(cities, ", ", states, sep = "")

    # Use the function geocode in the ggmap package to get the longitude
    # and latitude coordinates of the cities

    coords <- ldply(lapply(cities, geocode, output = "latlona"), data.frame)

    # Put all the city information into a data frame

    cities <- data.frame(file = files, address = coords$address,
        lon = coords$lon, lat = coords$lat)

    # Save the cities data frame

    save(cities, file = "cities.Rdata")

}

# The following if-else logic stores and loads downloaded data to speed
# up multiple runs

if(file.exists("data.Rdata")) {

    load("data.Rdata")

} else {

    # Build the URLs for downloading the data for the cities

    baseurl <- "http://academic.udayton.edu/kissock/http/Weather/gsod95-current/"
    urls <- paste(baseurl, cities$file, sep = "")

    # Decide the column names (consistent with the website description)

    col.names <- c("month", "day", "year", "temp")

    # Download the data using the "progress bar" version of lapply. Note
    # that missing data is coded as "-99" according to the website

    data <- pblapply(urls, read.table, col.names = col.names,
        na.strings = "-99")

    # Save the data

    save(data, file = "data.Rdata")

}

# Setup the function to calculate the average daily temperature swing
# for a given data frame of temperatures for a given city

meandiff <- function(df) {
    mean(abs(diff(df$temp)), na.rm = TRUE)
}

# Calculate the average daily temperature swing for each city

adts <- sapply(data, meandiff)

# Set character string for graph legend

legend.title <- "Avg Daily\nTemp Swing"

# Build graph

p <- qmap("united states", zoom = 3, maptype = "roadmap", legend = "bottomleft",
    color = "bw")
p <- p + geom_point(aes(x = lon, y = lat, size = adts, color = adts), data = cities,
    alpha = I(0.75))
p <- p + scale_size(name = legend.title)
p <- p + scale_color_gradient(name = legend.title, low = "green", high = "red")
p <- p + guides(color = guide_legend())

# Save two versions of graph

ggsave("temperature-swings-web.png", p, dpi = 100, width = 5, height = 5)
ggsave("temperature-swings.png", p, dpi = 300, width = 5, height = 5)
