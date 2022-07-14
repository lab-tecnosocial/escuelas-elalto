function(input, output, session) {

  # Map
  output$map <- renderLeaflet({
    leaflet(sf_tabla) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -68.105, lat = -16.525, zoom = 11) %>%
      addGeoJSON(el_alto_margen, weight = 2, fill = F) %>%
      addCircles(
        label = ~unidad_educativa,
        popup = ~paste0("<b>", unidad_educativa, "</b>", "<br>")
      )
  })


}
