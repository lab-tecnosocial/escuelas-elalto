library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(readxl)

cleantable <- read_excel("data/Matriz_Educacion2022_ElALto_24-06-22.xlsx")
