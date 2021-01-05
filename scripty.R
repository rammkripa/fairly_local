print("Hello World")
library(aiRly)
api_key <- Sys.getenv("airly_key")
set_apikey(api_key)
london_stations <- get_nearest_installations(lat = 51.5075,
                                             lng = -0.128,
                                             max_distance = 1000,
                                             max_results = -1)
library(geonames)
library(sf)
library(tidyverse)
library(rnaturalearth)
uk_map <- ne_countries(country = 'united kingdom', returnclass = "sf")
france_map <- ne_countries(country = 'france', returnclass = "sf")
uk_stations <- london_stations %>%
  filter(address$country == "United Kingdom")
ggplot()+
  geom_sf(data = uk_map) +
  geom_point(data = uk_stations$location, mapping = aes(x = longitude, y = latitude, color = uk_stations$is_airly))
library(stringi)
london_data <- uk_stations %>%
  filter(str_detect(address$city, "London"))
london_data
my_station <- get_nearest_measurements(lat = 51,
                                       lng = 0,
                                       max_distance = 20)
my_station$history %>%
  ggplot(mapping = aes(x = time$from, y = measure$PM25)) +
  geom_col()
new_london_data <- london_data %>%
  mutate(colortouse = if_else(is_airly, "red", "blue"))
library(leaflet)
leaflet() %>%
  addProviderTiles(providers$OpenTopoMap) %>%
  setView(-0.119,51.525, zoom = 8) %>%
  addCircleMarkers(lng = new_london_data$location$longitude,
                   lat = new_london_data$location$latitude,
                   color = new_london_data$colortouse) %>%
  addTiles ('https://tiles.macrostrat.org/carto/{z}/{x}/{y}.png', 
            options = tileOptions(opacity = 0.6))
  
