library(leaflet)

# Choices for drop-downs
vars <- c(
  "A" = "a",
  "B" = "b"
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

        selectInput("color", "Color", vars),
        selectInput("size", "Size", vars, selected = "adultpop"),
        conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
          # Only prompt for threshold when coloring or sizing by superzip
          numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
        ),

        plotOutput("histCentile", height = 200),
        plotOutput("scatterCollegeIncome", height = 250)
      ),

      tags$div(id="cite",
        'Datos GAMEA'
      )
    )
  ),

  tabPanel("Datos",
    fluidRow(
      column(3,
        selectInput("states", "Var1", c("All var1"=""), multiple=TRUE)
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("cities", "Var2", c("All var2"=""), multiple=TRUE)
        )
      ),
      column(3,
        conditionalPanel("input.states",
          selectInput("zipcodes", "Var3", c("All var3"=""), multiple=TRUE)
        )
      )
    ),
    fluidRow(
      column(1,
        numericInput("minScore", "Min score", min=0, max=100, value=0)
      ),
      column(1,
        numericInput("maxScore", "Max score", min=0, max=100, value=100)
      )
    ),
    hr(),
    DT::dataTableOutput("")
  ),

  conditionalPanel("false", icon("crosshair"))
)
