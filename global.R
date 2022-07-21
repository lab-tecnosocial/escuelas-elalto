library(shiny)
library(tidyverse)
library(leaflet)
library(RColorBrewer)
library(scales)
library(sf)
library(DT)


tabla <- read_csv("data/escuelas-ea-clean.csv")

# Transformar proyeccion: EPSG:32719 a EPSG:4326
sf_tabla <- tabla %>%
  filter(!is.na(x)) %>%
  st_as_sf(coords = c("x", "y"), crs = 32719)

sf_tabla <- st_transform(sf_tabla, crs = 4326)

# Cargar capa de area de El Alto
el_alto_distritos <- read_file("data/elalto_distritos.geojson")

# Mis funciones

count_prop <- function(df, col) {
  df %>%
    group_by({{col}}) %>%
    tally %>% 
    mutate(n_prop = round((n / sum(n) * 100), 1))
}
