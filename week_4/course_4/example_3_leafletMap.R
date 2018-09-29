# example_4_leafletMap

## References
### R Leaflet intro https://blog.gtwang.org/r/r-leaflet-interactive-map-package-tutorial/
### Leaflet for R official https://rstudio.github.io/leaflet/

## About GeoJson(there's various way to read geojson type data.)
### https://rstudio.github.io/leaflet/json.html
### https://stackoverflow.com/questions/31798360/how-do-i-use-the-addgeojson-feature-in-r-for-leaflet
### Draw with geojson.io http://blog.infographics.tw/2016/01/draw-map-with-geojson-io/


############################################################
library(leaflet)
library(jsonlite)

# Demo_use 
student.df <- data.frame(
  lng = 121.536823 + rnorm(5)/1000,
  lat = 25.018624 + rnorm(5)/1000,
  student.id = c("Eric", "Pat", "Billy", "Paul", "Kobe"),
  student.grade = c(70, 80, 70, 90, 95),
  student.class = c("A", "B", "A", "C", "B")
)

# Set color by grade
SetColor <- function(grade) {
  return(ifelse(grade > 75, "blue", "red"))
}

# Read geojson file
ntuGeoJson <- jsonlite::fromJSON("./ntu.geojson")

# Draw map with leaflet
map <- leaflet() %>%
  addTiles() %>% # Add default OpenStreetMap map tiles
  addGeoJSON(ntuGeoJson) %>% # Add ntuGeoJson layer
  addMarkers(
    lng = 121.536823,
    lat = 25.018624,
    popup = "where we are!") %>% # Add example marker
  setView(
    lng = 121.537, 
    lat = 25.018, 
    zoom = 16) %>% # Set the view of map
  addCircleMarkers(
    data = student.df,
    lng = ~lng,
    lat = ~lat,
    label = ~(paste(student.id, ", grade=> ", student.grade)), 
    radius = ~(student.grade/10),
    color = ~SetColor(student.grade),
    fill = T) # Add circle markers with student.df

map
