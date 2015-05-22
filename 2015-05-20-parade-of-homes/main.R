# Code written by Samuel Burer (samuel-burer@uiowa.edu) on 2015.05.22.
# Please provide credit if you use this code in any way.

# Clear workspace

rm(list = ls())

# Load libraries

library(XML)
library(stringr)
library(plyr)
library(ggmap)
library(leaflet)
library(knitr)

# The following if-else logic stores and loads downloaded data to speed
# up multiple runs

if(file.exists("houses.Rdata")) {

    load("houses.Rdata")

} else {

    # Download webpage (if it's not already saved)
    

    if(!file.exists("houses.html")) {
        url <- "http://iowacityhomes.thegazette.com/houses/"
        download.file(url = url, destfile = "houses.html")
    }

    # Parse webpage with listing of houses and labels

    hp <- htmlParse(readLines("houses.html"), asText = TRUE)

    # First capture house addresses

    addresses <- xpathSApply(hp, "//div[@class='home_list_item']//a", xmlValue)
    tmp1 <- addresses[2*(1:(length(addresses)/2))-1]
    tmp2 <- addresses[2*(1:(length(addresses)/2))]
    addresses <- paste(tmp1, ", ", tmp2, sep = "")
    addresses <- str_replace(addresses, "\\.", "")
    addresses <- str_replace(addresses, "  ", " ")
    addresses <- str_trim(addresses)

    # Manually adjust one address so that Google can determine lat-lon

    addresses[5] <- "Majestic Oak Ridge, Solon"

    # Add "IA" to addresses

    addresses <- paste(addresses, ", IA", sep = "")

    # Second capture Labels. A number means "New Construction", and a
    # letter means a "Remodel"

    labels <- xpathSApply(hp, "//div[@class='home_list_item']//a", xmlGetAttr, "href")
    labels <- labels[2*(1:(length(labels)/2))]
    labels <- str_replace(labels, "/home/", "")

    # Setup house types

    types <- vector(mode = "character", length = length(addresses))
    tmp <- sapply(suppressWarnings(as.integer(labels)), is.na) 
    types[tmp] <- "Remodel"
    types[!tmp] <- "New Construction"

    # Use the function geocode in the ggmap package to get the longitude
    # and latitude coordinates of the addresses

    coords <- ldply(lapply(addresses, geocode, output = "latlona"), data.frame)
    coords$address <- as.character(coords$address)

    # Manually adjust one lat-lon that Google could not determine. Also
    # add address for route searching. From the Parade website: "Take
    # Hwy. 6 west to Tiffin. Right onto Roberts Ferry Rd. Right onto
    # Oakdale Blvd. Left onto Cherry Lane. Left onto Dogwood Lane."

    coords$lat[12] <- 41.7173
    coords$lon[12] <- -91.6611
    coords$address[12] <- "Cherry Ln, Tiffin, IA 52340"

    # Put all the city information into a data frame

    houses <- data.frame(address.website = addresses, address.google =
        coords$address, lon = coords$lon, lat = coords$lat, label =
        labels, type = types, stringsAsFactors = FALSE)
    houses$type <- as.factor(houses$type)

    # Save the cities data frame

    save(houses, file = "houses.Rdata")

}

# Set the dimension (number of houses)

n <- nrow(houses)

# Open or initialize the distances matrix

if(file.exists("distances.Rdata")) {

    load("distances.Rdata")

} else {

    distances <- matrix(data = 0, nrow = n, ncol = n)

}

# Retrieve travel distances (in minutes) from Google

for(i in 2:n) {
    for(j in 1:(i-1)) {
        if(distances[i, j] == 0) {
            rt <- route(houses$address.google[i], houses$address.google[j],
                mode = "driving", structure = "legs", output = "simple")
            distances[i, j] <- sum(rt$minutes)
            Sys.sleep(0.5) # Just to give web requests time, which seemed
                           # to avoid some errors
        }
        distances[j, i] <- distances[i, j]
    }
}

# Save the distances matrix

save(distances, file = "distances.Rdata")

# Create TSP instance

sink(file = "tmptsp.tsp")
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

# Solve TSP instance

system("tsp/concorde/TSP/concorde tmptsp.tsp")

# Read TSP solution

tour <- readLines("tmptsp.sol")
tour <- paste(tour, collapse = " ")
tour <- str_split(tour, " ")
tour <- unlist(tour)
tour <- tour[tour != ""]
tour <- tour[tour != as.character(n)]
tour <- as.integer(tour) + 1

# Clean up TSP details

system("rm -rf *tmptsp*")

# Calculate and print tour length (in minutes)

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

# Setup and print Leaflet map of tour

m <- leaflet(houses)
m <- addTiles(m)
m <- addCircles(m, lng = ~lon, lat = ~lat, weight = 1, radius = 750,
    popup = ~address.website, fillOpacity = 0.5)
m <- addPolylines(m, lng = ~lon[c(tour,1)], lat = ~lat[c(tour,1)],
                  fillColor = "red")
print(m)

# Print markdown table of tour (first some final tweaks)

houses$address.website <- str_replace(houses$address.website, "\\.", "")
houses$address.website <- str_replace(houses$address.website, ", IA", "")
print(kable(houses[tour, c("label", "address.website", "type")], row.names = FALSE))
