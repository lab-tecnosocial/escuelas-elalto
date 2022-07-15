library(tidyverse)
library(readxl)

tabla <- read_excel("data/Matriz_Educacion2022_ElALto_24-06-22.xlsx")

# Mejorar nombres de columnas
nombres_cols <- c(
  "distrito",
  "codigo_sie",
  "unidad_educativa",
  "x",
  "y",
  "estado",
  "nivel_educativo",
  "luz_electrica",
  "agua_potable",
  "alcantarillado",
  "pozo_septico",
  "baños",
  "lava_manos",
  "internet",
  "laboratorios",
  "sala_computacion",
  "nombre_mañana",
  "nombre_tarde",
  "nombre_noche",
  "pob_mañana",
  "pob_tarde",
  "pob_noche"
)
colnames(tabla) <- nombres_cols

# Poner NAs
tabla[16, "estado"] <- NA

# Convertir numericos a factores
tabla <- tabla %>%
  mutate(across(luz_electrica:sala_computacion, ~fct_recode(as.factor(.x), "Sí" = "1", "No" = "2"))) %>%
  mutate(estado = fct_recode(as.factor(estado), "Bueno" = "1", "Regular" = "2", "Malo" = "3"))

# Crear columnas utiles
tabla <- tabla %>%
  mutate(turno = case_when(
    !is.na(nombre_mañana) & is.na(nombre_tarde) & is.na(nombre_noche) ~ "Mañana",
    is.na(nombre_mañana) & !is.na(nombre_tarde) & is.na(nombre_noche) ~ "Tarde",
    is.na(nombre_mañana) & is.na(nombre_tarde) & !is.na(nombre_noche) ~ "Noche",
    TRUE ~ "Mañana"
  ), .after = sala_computacion)

# Unir columnas innecesariamente separadas
tabla <- tabla %>%
  unite(`pob_mañana`, pob_tarde, pob_noche, col = "pob", sep = "", remove = F, na.rm = T)

# Duplicar filas para turnos diferentes
# . . .

# Guardar tabla limpia
write_csv(tabla, "data/escuelas-ea-clean.csv")




