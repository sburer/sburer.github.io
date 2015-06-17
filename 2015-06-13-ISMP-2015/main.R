# Clear workspace

rm(list = ls())

# Load libraries

library(XML)
library(RCurl)
library(stringr)
library(RDSTK)
library(dplyr)
library(pbapply)
library(ggplot2)
library(geosphere)
library(ggmap)

# Get participant information. This required pre-downloading the daily
# list of sessions from the ISMP 2015 website. The files are saved as
# day1.html, day2.html, etc.

if(!file.exists("participants.Rdata")) {

    # Create helper function

    get_char_rel_pos <- function(x, pos) {
        lx <- length(x)
        if(lx >= abs(pos)) {
            if(pos > 0) {
                res <- x[pos]
            } else {
                res <- x[lx + 1 + pos]
            }
        } else {
            res <- NA
        }
        res
    }

    # Setup constants

    days <- paste("day", 1:5, sep = "")
    urlbase <- "https://informs.emeetingsonline.com"

    # Initialize columns of data that we will extract

    day <- vector(mode = "character", length = 0)
    session <- vector(mode = "integer", length = 0)
    city <- vector(mode = "character", length = 0)
    country <- vector(mode = "character", length = 0)
    domain <- vector(mode = "character", length = 0)

    for(j in seq_along(days)) {

        # Get links in file

        filename <- paste(days[j], ".html", sep = "")
        hp <- htmlParse(readLines(filename), asText = TRUE)
        links <- xpathSApply(hp, "//a/@href")
        names(links) <- NULL

        # Loop of links found

        for(i in seq_along(links)) {

            # Download HTML file and extract table

            url <- paste(urlbase, links[i], sep = "")
            tables <- readHTMLTable(getURL(url), stringsAsFactors = FALSE)
            df <- tables[[1]]

            # Find rows in table corresponding to session chair and
            # presenting authors

            wh_chair <- df$V1 == "Chair:" & !is.na(df$V1)
            wh_presenting <- df$V2 == "Presenting Author:" & !is.na(df$V2)

            # If some matching rows were found

            if(sum(wh_chair) + sum(wh_presenting) > 0) {

                # Extract participant information

                people <- c(df[wh_chair, "V2"], df[wh_presenting, "V3"])
                #people <- iconv(people, "latin1", "ASCII", sub = "")

                # Split at the @ symbol (hopefully just one instance
                # corresponding to an email address)

                people <- strsplit(people, "@", fixed = TRUE)

                # Extract what will become country information

                co <- sapply(people, "[[", 1)

                # Split by comma

                co <- strsplit(co, ", ", fixed = TRUE)

                # Extract city information

                ci <- sapply(co, get_char_rel_pos, -3)

                # Extract country information

                co <- sapply(co, get_char_rel_pos, -2)

                # Extract domain information

                do <- sapply(people, get_char_rel_pos, 2)

                # Append day, session, country, city, and domain
                # information

                day <- c(day, rep(days[j], length(co)))
                session <- c(session, rep(i, length(co)))
                country <- c(country, co)
                city <- c(city, ci)
                domain <- c(domain, do)

            }

        }

    }

    # Create participants data frame

    participants <- data.frame(day, session, city, country, domain,
                               stringsAsFactors = FALSE)

    save(participants, file = "participants.Rdata")

} else {
    
    load("participants.Rdata")

    # Implement manual fix

    warning("Manual fix implemented by Sam on 2015.06.14")
    participants$domain <- as.character(participants$domain)
    participants$domain[600] <- "uni-kassel.de"

}

# Watch out! Switching from particpants to pts!

pts <- participants

# Convert all domains to lower case

pts$domain <- tolower(pts$domain)

# Create helper function to trim domains

simplify_domain <- function(x, suffix, total_length) {
    suffix <- paste(".", suffix, sep = "")
    ss <- str_sub(x, start = nchar(x) - nchar(suffix) + 1, end = -1)
    if(!is.na(ss) && ss == suffix) {
        loc <- str_locate_all(x, "\\.")[[1]]
        m <- nrow(loc)
        if(m >= total_length) {
            res <- str_sub(x, start = loc[m-total_length+1,1]+1, end = -1)
        } else {
            res <- x
        }
    } else {
        res <- x
    }
    res
}

# Simplify length-2 domains

length_2 <- c("gov", "com", "edu", "ca", "ch", "cl", "de", "fr", "gr", "it",
    "nl", "no", "hu")

for(ind in seq_along(length_2)) {
    pts$domain <- sapply(pts$domain, simplify_domain, length_2[ind], 2,
                         USE.NAMES = FALSE)
}

# Simplify length-3 domains

length_3 <- c("jp", "hk", "uk", "cn", "nz", "in", "co", "om", "sg", "il")

for(ind in seq_along(length_3)) {
    pts$domain <- sapply(pts$domain, simplify_domain, length_3[ind], 3,
                         USE.NAMES = FALSE)
}

# Collapse those that use multiple domain formats

pts$domain[pts$domain == "nus.edu"] <- "nus.edu.sg"

# Clean up. This includes deleting the very generic domans

pts <- pts[!is.na(pts$domain), ]
pts <- pts[pts$domain != "gmail.com", ]
pts <- pts[pts$domain != "yahoo.com", ]
pts <- pts[pts$domain != "126.com", ]
pts <- pts[pts$domain != "163.com", ]

# Turn domain into a factor

pts$domain <- as.factor(pts$domain)

# Create a unique session identifier

pts$sess <- paste(pts$day, pts$session, sep = "_")

# Reduce pts to just four columns

pts <- pts[, c("sess", "domain", "city", "country")] 

#
# Begin converting domains to lat-lon
#

# Create function to get lat-lon. Based on searching domain, but falls
# back to city-country if necessary

get_latlon_with_failsafe <- function(dom) {

    res <- ip2coordinates(dom)
    if(nrow(res) == 1) {
        lat <- res$latitude
        lon <- res$longitude
    } else {
        wh <- grep(pattern = dom, x = pts$domain)
        add <- paste(pts$city[wh[1]], pts$country[wh[1]], sep = ", ")
        res <- geocode(add)
        if(nrow(res) == 1) {
            lat <- res$lat
            lon <- res$lon
        } else {
            lat <- NA
            lon <- NA
        }
    }
    data.frame(lat, lon)

}

# Get list of unique domains

domains <- as.character(unique(pts$domain))

# Get list of lat-lon for domains

if(!file.exists("coordinates.Rdata")) {
    coordinates <- pblapply(domains, get_latlon_with_failsafe)
    save(coordinates, file = "coordinates.Rdata")
} else {
    load("coordinates.Rdata")
}

# Convert the list to a data frame

coordinates <- do.call(rbind.data.frame, coordinates)

# Put the domains in the data frame, too. Do some simple reordering

coordinates$domain <- domains
coordinates <- coordinates[, c(3, 1, 2)]
coordinates <- coordinates[order(coordinates$domain), ]

#
# End converting domains to lat-lon
#

# Count how often each domain appears in the pts data frame. Add that
# information to the coordinates data frame

pts <- group_by(pts, domain)
tmp <- summarize(pts, freq = n())
tmp <- tmp[order(tmp$domain), ] # Important for matching next line!
coordinates$freq <- tmp$freq
pts <- ungroup(pts)

# Join pts with itself

tmp <- full_join(pts, pts, by = c("sess" = "sess"))

# Group by domain pairs

tmp <- group_by(tmp, domain.x, domain.y)

# Count how often each domain pair appears

tmp <- summarize(tmp, freq = n())

# Delete redundant pairs

wh <- as.character(tmp$domain.x) < as.character(tmp$domain.y)
tmp <- tmp[wh, ]

# Reorder by decreasing freq

tmp <- tmp[order(tmp$freq, decreasing = TRUE), ]

# Now do a left join to add the coordinates of the "x" domain. Then do
# the same for "y"

tmp <- left_join(tmp, coordinates, by = c("domain.x" = "domain"))
tmp <- left_join(tmp, coordinates, by = c("domain.y" = "domain"))

# Keep just the info we need, called "paths"

paths <- tmp[, c("lon.x", "lat.x", "lon.y", "lat.y", "freq.x")]
names(paths)[names(paths) == "freq.x"] <- "freq"

# Reduce to just complete cases

paths <- paths[complete.cases(paths), ]

# Take a small subset for quicker compiles

#paths <- paths[1:30, ]

# Separate into beginning and end of paths

paths_x <- paths[, c("lon.x", "lat.x")]
paths_y <- paths[, c("lon.y", "lat.y")]

# Calculate great-circle paths

great_circles <- gcIntermediate(paths_x, paths_y, n = 150, addStartEnd = FALSE)

# Initialize the plot. I plot the points at
# the end so that they are in front. See also
# http://stackoverflow.com/questions/11201997/world-map-with-ggmap

p <- ggplot() + borders("world", colour="gray75", fill="gray75")

# Plot paths

maxfreq <- max(paths$freq)
for(j in seq_along(great_circles)) {
    #print(j)
    #print(dim(t))
    gc <- as.data.frame(great_circles[j])
    if(nrow(gc) > 1) { # Some domains, like gurobi.com and zib.de had same coords (?)
        p <- p + geom_line(
            aes(x = lon, y = lat),
            data = gc,
            color = I("darkred"),
            alpha = I(paths$freq[j]/maxfreq),
            size = I(paths$freq[j]/maxfreq)
            )
    }
}

# Plot points

p <- p + geom_point(aes(x = lon, y = lat, size = freq),
                      data = coordinates,
                      color = I("blue"),
                      alpha = I(0.4))

# Adjust size (but legend eventually supressed)

p <- p + scale_size(name = "Number of\nSpeakers and\nSession Chairs",
    range = c(2, 6))

# Set title (now suppressed)

#p <- p + ggtitle("Contributions and Connections at ISMP 2015")
#p <- p + theme(plot.title = element_text(size = 20, face = "bold"))

# Remove various elements

p <- p + theme(axis.title.y = element_blank()) 
p <- p + theme(axis.text.y = element_blank())
p <- p + theme(axis.ticks.y = element_blank())
p <- p + theme(axis.title.x = element_blank()) 
p <- p + theme(axis.text.x = element_blank())
p <- p + theme(axis.ticks.x = element_blank())
p <- p + theme(panel.grid = element_blank())
p <- p + theme(legend.position = "none")

# Set caption (now suppressed)

#p <- p + xlab("Dots represent institutions, and size indicates number of speakers and session chairs.\nConnections represent sessions in common, and the more intense, the more sessions in common.")

# Add my "signature"

p <- p + annotate(geom="text", x = 120, y = -75,
    label="Samuel Burer, June 2015", size = 3)

# Save various versions

ggsave("ISMP-2015-web.png", p, dpi = 85, width = 9, height = 5)
ggsave("ISMP-2015.png", p, dpi = 300, width = 9, height = 5)
ggsave("ISMP-2015.svg", p, width = 9, height = 5)
