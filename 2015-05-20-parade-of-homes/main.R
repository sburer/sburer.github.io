# Code written by Samuel Burer (samuel-burer@uiowa.edu) on 2015.05.20.
# Please provide credit if you use this code in any way.

# Clear workspace

rm(list = ls())

# Load libraries

library(XML)
library(stringr)
library(plyr)
library(ggmap)
#library(ggplot2)
#library(pbapply)


# Function

#mycap <- function(mystr = "") {
    #mystr <- tolower(mystr)
    #mylist <- strsplit(mystr, split = " ", fixed = TRUE)
    #vec <- unlist(mylist)
    #for(i in 1:length(vec)) {
        #a <- substr(vec[i], start = 1, stop = 1)
        #b <- substr(vec[i], start = 2, stop = nchar(vec[i]))
        #vec[i] <- paste(toupper(a), b, sep = "")
    #}
    #mystr <- paste(vec, sep = "", collapse = " ")
    #mystr
#}


# The following if-else logic stores and loads downloaded data to speed
# up multiple runs

if(file.exists("houses.Rdata")) {

    load("houses.Rdata")

} else {

    # Download and parse webpage with listing of locations/cities

    url <- "http://iowacityhomes.thegazette.com/houses/"
    hp <- htmlParse(readLines(url), asText = TRUE)

    # Capture filenames for cities

    houses <- xpathSApply(hp, "//div[@class='home_list_item']//a", xmlValue)
    tmp1 <- houses[2*(1:(length(houses)/2))-1]
    tmp2 <- houses[2*(1:(length(houses)/2))]
    houses <- paste(tmp1, ", ", tmp2, sep = "")
    houses <- str_replace(houses, "\\.", "")
    houses <- str_trim(houses)

    # Manually adjust one address so that Google can determine lat-lon

    houses[5] <- "Majestic Oak Ridge, Solon"

    # Add "IA" to addresses

    houses <- paste(houses, ", IA", sep = "")

    # Use the function geocode in the ggmap package to get the longitude
    # and latitude coordinates of the cities

    coords <- ldply(lapply(houses, geocode, output = "latlona"), data.frame)
    coords$address <- as.character(coords$address)

    # Manually adjust one lat-lon that Google could not determine. Also
    # add address for route searching. From the Parade website: "Take
    # Hwy. 6 west to Tiffin. Right onto Roberts Ferry Rd. Right onto
    # Oakdale Blvd. Left onto Cherry Lane. Left onto Dogwood Lane."

    coords$lat[12] <- 41.7173
    coords$lon[12] <- -91.6611
    coords$address[12] <- "Cherry Ln, Tiffin, IA 52340"

    # Put all the city information into a data frame

    houses <- data.frame(address.website = houses, address.google =
        coords$address, lon = coords$lon, lat = coords$lat,
        stringsAsFactors = FALSE)

    # Save the cities data frame

    save(houses, file = "houses.Rdata")

}

#p <- qmap("iowa city, ia", zoom = 10, maptype = "roadmap", legend = "bottomleft",
    #color = "bw")
#p <- p + geom_point(aes(x = lon, y = lat), color = I("blue"), data = houses,
    #alpha = I(0.75))
#ggsave("tmp.png", p, dpi = 300, width = 5, height = 5)
#print(p)

#houses <- houses[1:10, ]

if(file.exists("distances.Rdata")) {

    load("distances.Rdata")

} else {

    distances <- matrix(data = 0, nrow = n, ncol = n)

}

n <- nrow(houses)

for(i in 2:n) {
    for(j in 1:(i-1)) {
        if(distances[i, j] == 0) {
            rt <- route(houses$address.google[i], houses$address.google[j],
                mode = "driving", structure = "legs", output = "simple")
            distances[i, j] <- sum(rt$minutes)
            #Sys.sleep(1)
        }
        distances[j, i] <- distances[i, j]
    }
}

# Save the distances matrix

save(distances, file = "distances.Rdata")

sink(file = "tsptmp.tsp")
cat("NAME : (none)\n")
cat("COMMENT : (none)\n")
cat("TYPE : TSP\n")
cat(sprintf("DIMENSION : %d\n", n))
cat("COMMENT : (none)\n")
cat("EDGE_WEIGHT_TYPE : EXPLICIT\n")
cat("EDGE_WEIGHT_FORMAT : UPPER_ROW\n")
cat("DISPLAY_DATA_TYPE : NO_DISPLAY\n")
cat("EDGE_WEIGHT_SECTION : ")
for(i in 1:n-1) {
    cat("  ")
    for(j in (i+1):n) {
        cat(sprintf("%3d ", round(1000*distances[i, j]))) # Must be rounded to integer!
    }
    cat("\n")
}
cat("EOF :\n")
sink()

system("tsp/concorde/TSP/concorde tsptmp.tsp")

tour <- readLines("tsptmp.sol")
tour <- paste(tour, collapse = " ")
tour <- str_split(tour, " ")
tour <- unlist(tour)
tour <- tour[tour != ""]
tour <- tour[tour != as.character(n)]
tour <- as.integer(tour) + 1
tour_length <- 0
for(i in 1:n) {
    if(i == n) {
        j <- 1
    } else {
        j <- i + 1
    }
    tour_length <- tour_length + distances[tour[i], tour[j]]
}
print(tour_length)

system("rm -rf *tsptmp*")

library(leaflet)

#pal <- colorNumeric(
  #palette = c("green", "red"),
  #domain = cities$adts
#)

m <- leaflet(houses)
m <- addTiles(m)
m <- addCircles(m, lng = ~lon, lat = ~lat, weight = 1, radius = 750,
    popup = ~address.website, fillOpacity = 0.5)
m <- addPolylines(m, lng = ~lon[c(tour,1)], lat = ~lat[c(tour,1)],
                  fillColor = "red")
print(m)

# color = ~pal(adts), 

#cat("DISPLAY_DATA_SECTION : \n")
#for i = 1:n
  #fprintf(fid, '  %3d  %10.5f  %10.5f\n', i, x(i), y(i));
#end


# The following if-else logic stores and loads downloaded data to speed
# up multiple runs

#if(file.exists("data.Rdata")) {

    #load("data.Rdata")

#} else {

    ## Build the URLs for downloading the data for the cities

    #baseurl <- "http://academic.udayton.edu/kissock/http/Weather/gsod95-current/"
    #urls <- paste(baseurl, cities$file, sep = "")

    ## Decide the column names (consistent with the website description)

    #col.names <- c("month", "day", "year", "temp")

    ## Download the data using the "progress bar" version of lapply. Note
    ## that missing data is coded as "-99" according to the website

    #data <- pblapply(urls, read.table, col.names = col.names,
        #na.strings = "-99")

    ## Save the data

    #save(data, file = "data.Rdata")

#}

# Setup the function to calculate the average daily temperature swing
# for a given data frame of temperatures for a given city

#meandiff <- function(df) {
    #mean(abs(diff(df$temp)), na.rm = TRUE)
#}

# Calculate the average daily temperature swing for each city

#cities$adts <- sapply(data, meandiff)

# Set character string for graph legend

#legend.title <- "Avg Daily\nTemp Swing"

# Build graph

#p <- qmap("united states", zoom = 3, maptype = "roadmap", legend = "bottomleft",
    #color = "bw")
#p <- p + geom_point(aes(x = lon, y = lat, size = adts, color = adts), data = cities,
    #alpha = I(0.75))
#p <- p + scale_size(name = legend.title)
#p <- p + scale_color_gradient(name = legend.title, low = "green", high = "red")
#p <- p + guides(color = guide_legend())

# Save two versions of graph

#ggsave("temperature-swings-web.png", p, dpi = 100, width = 5, height = 5)
#ggsave("temperature-swings.png", p, dpi = 300, width = 5, height = 5)
