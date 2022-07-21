library(leaflet)

# Opciones para listas de seleccion
turno_list <- c(
  "Mañana" = "Mañana",
  "Tarde" = "Tarde",
  "Noche" = "Noche"
)

estado_list <- c(
  "Todo" = "Todos",
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
        selectInput("estado", tags$b("Estado"), estado_list, selected = "Todos"),
        h4("Población"),
        textOutput("poblacionPlot"),
        h4("Estado"),
        plotOutput("estadoPlot", height = 200),
        h4("Porcentaje de servicios"),
        plotOutput("serviciosPlot", height = 200)
     
      ),

      tags$div(id="cite",
        "Datos GAMEA",
        " - ",
        "Desarrollado por el", 
        a("Lab TecnoSocial", href="https://labtecnosocial.org/")
      )
    )
  ),
  tabPanel("Datos",
           fluidRow(
             column(3,
                    selectInput("distritoTab", "Distrito", unique(sf_tabla$distrito), selected = "D-1")
             ),
             column(3,
                    selectInput("nivelTab", "Nivel educativo", unique(sf_tabla$nivel_educativo), selected = "I-P-S")
             ),
             column(3,
                    selectInput("estadoTab", "Estado", c("Bueno", "Regular", "Malo"), selected = "Regular")
             )
           ),
           hr(),
           DT::dataTableOutput("tablaOutput")
  )
)
