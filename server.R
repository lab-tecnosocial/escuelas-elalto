function(input, output, session) {

  # Map
  output$map <- renderLeaflet({
    data <- sf_tabla %>%
      filter(turno == input$turno & estado == input$estado)
    
    leaflet(data) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -68.105, lat = -16.525, zoom = 11) %>%
      addGeoJSON(el_alto_margen, weight = 2, fill = F) %>%
      addCircles(
        label = ~unidad_educativa,
        popup = ~paste0(
          "<b>", unidad_educativa, "</b>", "<br>",
          "Distrito: ", distrito, "<br>",
          "Turno: ", turno, "<br>",
          "Nivel educativo: ", nivel_educativo, "<br>",
          "Estado: ", estado, "<br>"
          )
      )
  })


}
