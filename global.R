library(shiny)
library(tidyverse)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(readxl)
library(sf)


# transformar proyeccion: EPSG:32719 a EPSG:4326
tabla <- read_excel("data/Matriz_Educacion2022_ElALto_24-06-22.xlsx")

sf_tabla <- tabla %>%
  filter(!is.na(X)) %>%
  st_as_sf(coords = c("X", "Y"), crs = 32719)

sf_tabla <- st_transform(sf_tabla, crs = 4326)

# clean_table <- st_transform()


el_alto_margen <- read_file("data/elalto.geojson")


