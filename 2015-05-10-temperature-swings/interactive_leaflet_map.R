library(leaflet)

pal <- colorNumeric(
  palette = c("green", "red"),
  domain = cities$adts
)

m <- leaflet(cities)
m <- addTiles(m)
m <- addCircles(m, lng = ~lon, lat = ~lat, weight = 1, radius = ~adts*20000,
    popup = ~address, color = ~pal(adts), fillOpacity = 0.75)
print(m)

