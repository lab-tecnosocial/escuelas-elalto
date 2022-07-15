library(leaflet)

# Opciones para listas de seleccion
turno_list <- c(
  "Mañana" = "Mañana",
  "Tarde" = "Tarde",
  "Noche" = "Noche"
)

estado_list <- c(
  "Bueno" = "Bueno",
  "Regular" = "Regular",
  "Malo" = "Malo"
)

navbarPage("Escuelas en El Alto", id="nav",

  tabPanel("Mapa interactivo",
    div(class="outer",

      tags$head(
        includeCSS("styles.css"),
      ),
      leafletOutput("map", width="100%", height="100%"),
      
      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",

        h2("Filtros"),

        selectInput("turno", tags$b("Turno"), turno_list, selected = "Mañana"),
        selectInput("estado", tags$b("Estado"), estado_list, selected = "Regular"),
        h4("Porcentaje de servicios"),
        plotOutput("serviciosPlot", height = 200),
        h4("Población"),
        plotOutput("poblacionPlot", height = 200)
      ),

      tags$div(id="cite",
        "Datos GAMEA",
        " - ",
        "Desarrollado por el", 
        a("LabTecnoSocial", href="https://labtecnosocial.org/")
      )
    )
  )
)
