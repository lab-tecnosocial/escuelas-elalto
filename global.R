library(shiny)
library(tidyverse)
library(leaflet)
library(RColorBrewer)
library(scales)
library(sf)
library(DT)

# Mapa base de CARTO. Desde agosto de 2026 CARTO exige API key en sus teselas
# raster: sin ella responde HTTP 200 con un PNG de marca de agua "API KEY
# REQUIRED", sin ningún error visible. `addProviderTiles()` no admite pasar
# parámetros a la URL, así que el mapa base se arma con `addTiles()` sobre la
# plantilla completa. La key es la gratuita del Lab y no es secreta (va en cada
# petición del navegador).
carto_tiles <- function(estilo) {
  paste0(
    "https://{s}.basemaps.cartocdn.com/", estilo,
    "/{z}/{x}/{y}{r}.png?key=cb1_2i09_1_c1733caff4f6b0fa830d7eeb"
  )
}

# La atribución la ponía `addProviderTiles()` por su cuenta; al pasar a
# `addTiles()` hay que declararla explícitamente. El tier gratuito de CARTO
# exige mantenerla visible.
CARTO_ATRIBUCION <- paste0(
  '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> ',
  '&copy; <a href="https://carto.com/attributions">CARTO</a>'
)


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
