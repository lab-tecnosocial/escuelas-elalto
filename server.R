function(input, output, session) {

  # Map
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -68.205, lat = -16.525, zoom = 12)
  })


}
