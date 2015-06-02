# Load libraries

library(stringr)
library(ggmap)

# Clear workspace

rm(list = ls())

# Create helper functions

# This is just so I don't have to type 'suppressWarnings'
sW <- function(arg) {
    suppressWarnings(arg)
}

# This is just so the code doesn't fail on an error
my.err.handler <- function(error) {
    error
}

# Download Trader Joe's listing of all its stores (if it has not already
# been downloaded)

if(!file.exists("Trader-Joes-Stores.pdf")) {
    download.file(url = "http://www.traderjoes.com/pdf/Trader-Joes-Stores.pdf",
        destfile = "Trader-Joes-Stores.pdf")
}

# Convert the PDF to text (if it hasn't already been converted). For
# this I had to install xpdf through MacPorts

if(!file.exists("Trader-Joes-Stores.txt")) {
    system("xpdf-pdftotext Trader-Joes-Stores.pdf")
}

# If the file stores.Rdata doesn't exist, initialize it

if(!file.exists("stores.Rdata")) {

    # Read the text file

    text <- sW(readLines("Trader-Joes-Stores.txt"))

    # Create the "logical OR" list of state abbreviations. Uses R's
    # built-in state.abb character vector

    states <- paste(", ", state.abb, sep = "", collapse="|")

    # Find state abbreviations in the text file

    matches <- sW(unique(grep(pattern = states, text)))

    # Begin manual tweaks
    # Begin manual tweaks
    # Begin manual tweaks

    # The vast majority of addresses were on single lines, but a few
    # were broken across two lines. Key observation is that each address
    # should start with a number. Find those matches which require the
    # preceding line

    tmp <- sW(which(is.na(as.numeric(str_sub(text[matches], 1, 1)))))
    tmp <- matches[tmp]

    # Prepend the required preceding lines

    text[tmp] <- paste(text[tmp-1], text[tmp], sep = ", ")

    # Fix one entry that had extra directions in address, which were
    # messing up Google's ability to geocode it

    text[750] <- "6610 Marie Curie Dr, Elkridge, MD 21075"

    # End manual tweaks
    # End manual tweaks
    # End manual tweaks

    # Finalize list of store addresses

    stores <- text[matches]

    # Clean up a bit

    loc <- as.data.frame(str_locate(stores, states))
    stores <- str_sub(stores, 1, loc$end + 6)

    # Setup data frame with space for lon, lat, etc.
    
    df <- data.frame(address.tj = stores, stringsAsFactors = FALSE)
    df$lon <- NA
    df$lat <- NA
    df$address.google <- NA
    df$error <- NA

    # Save the stores.Rdata file. Note that the data frame is called
    # "df", not "stores"

    save(df, file = "stores.Rdata")

# Otherwise, if stores.Rdata does exist, load it

} else {

    load("stores.Rdata")

}

# Proceed to geocode the addresses. First set the query limit

limit <- 500

# Find the stores that haven't been geocoded yet

wh <- which(is.na(df$lat) & is.na(df$lon) & is.na(df$address.google) &
    is.na(df$error))

# If there are still addresses to geocode...

if(length(wh) > 0) {

    # Do not exceed the geocode limit

    wh <- wh[1:min(limit, length(wh))]

    # Loop over addresses

    for(ind in 1:length(wh)) {

        # Geocode the address

        coord <- tryCatch(
            geocode(df$address.tj[wh[ind]], output = "latlona"),
            error = my.err.handler,
            warning = my.err.handler
        )

        # If there was an error...

        if(is.null(coord$address) || is.na(coord$lat)) {

            # Flag the error

            df$error[wh[ind]] <- TRUE

        # Otherwise, save the results

        } else {

            coord$address <- as.character(coord$address)
            df$lon[wh[ind]] <- coord$lon[1]
            df$lat[wh[ind]] <- coord$lat[1]
            df$address.google[wh[ind]] <- coord$address[1]
            df$error[wh[ind]] <- FALSE

        }

        # Write compressed CSV file

        bz <- bzfile("stores.csv.bz2", "w")
        write.csv(df, bz, row.names = FALSE)
        close(bz)

        # Save the updated stores information

        save(df, file = "stores.Rdata")

    # End for loop

    }

# End if

}

# Write compressed CSV file

bz <- bzfile("stores.csv.bz2", "w")
write.csv(df, bz, row.names = FALSE)
close(bz)

# Save the final stores information

save(df, file = "stores.Rdata")

# Now geocode the actual DC locations that I found. Code is similar to
# the above code

if(file.exists("DCs.Rdata")) {

    load("DCs.Rdata")

} else {

    address <- c(
        "Daytona Beach, FL",
        "Bath, PA",
        "Irving, TX",
        "Stockton, CA",
        "Sewanee, GA",
        "Minooka, IL"
        )

    DCs <- data.frame(address, stringsAsFactors = FALSE)
    DCs$lat <- NA
    DCs$lon <- NA
    for(i in 1:nrow(DCs)) {
        gc <- geocode(DCs$address[i])
        DCs$lat[i] <- gc$lat
        DCs$lon[i] <- gc$lon
    }

    save(DCs, file = "DCs.Rdata")

}

# Build a first plot of the USA

p <- qmap("united states", zoom = 4, maptype = "roadmap", color = "bw")

# Add the stores to the plot

p <- p + geom_point(aes(x = lon, y = lat), data = df, alpha = I(0.5),
    color = I("blue"), size = 3)

# Calculate the k-means clusters and centers

subdf <- df[, c("lon", "lat")]
subdf <- subdf[complete.cases(subdf), ]
num_DCs <- ceiling(sqrt(nrow(df))) # Just a guess
km <- kmeans(subdf, num_DCs)
centers <- as.data.frame(km$centers)
names(centers) <- c("c.lon", "c.lat")
subdf <- cbind(subdf, centers[km$cluster, ])

# Add to the plot line segments between stores and centers

p <- p + geom_segment(aes(x = lon, y = lat, xend = c.lon, yend = c.lat),
    data = subdf)

# Add centers to the plot

p <- p + geom_point(aes(x = c.lon, y = c.lat), data = centers, alpha = I(0.75),
    color = I("red"), size = 3)

# Add true DC locations

p <- p + geom_point(aes(x = lon, y = lat), data = DCs, 
    color = I("green"), size = 3)

# Save plot (both low- and high-resolution)

ggsave("Trader-Joes-Stores-web.png", p, dpi = 100, width = 5, height = 5)
ggsave("Trader-Joes-Stores.png", p, dpi = 300, width = 5, height = 5)
