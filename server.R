function(input, output, session) {
  datos <- reactive({
    validate(
      need(!(input$turno == "Noche" & input$estado == "Bueno"), "No hay coincidencias")
    )
    if(input$estado == "Todos"){
      sf_tabla %>%
        filter(turno == input$turno)
    } else {
    sf_tabla %>%
      filter(turno == input$turno & estado == input$estado)
    }
  })
  
  # Mapa
  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(
      attributionControl=FALSE)) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(lng = -68.105, lat = -16.525, zoom = 11) %>%
      addGeoJSON(el_alto_distritos, weight = 2, fill = F)
  })

  # Actualizacion de mapa
  observe({
    leafletProxy("map", data = datos()) %>%
      clearShapes() %>%
      addCircles(
        label = ~unidad_educativa,
        popup = ~paste0(
          "<b>", unidad_educativa, "</b>", "<br>",
          "Distrito: ", distrito, "<br>",
          "Turno: ", turno, "<br>",
          "Nivel educativo: ", nivel_educativo, "<br>",
          "Población: ", pob, "<br>",
          "Estado: ", estado, "<br>"
        )
      )
      
  })

  
  
  # Graficos
  output$estadoPlot <- renderPlot({
    datos() %>%
      st_drop_geometry() %>%
      filter(!is.na(estado)) %>%
      count_prop(estado) %>%
      mutate(estado = fct_relevel(estado, "Bueno", "Regular")) %>%
      ggplot(aes(x = "", y = n_prop, fill = estado)) +
      geom_col() +
      geom_text(aes(label = paste0(n_prop, "%")), position = position_stack(vjust = 0.5), color = "white", size = 3) +
      coord_polar(theta = "y") +
      scale_fill_brewer() +
      theme_void()
    
  })
  
  output$serviciosPlot <- renderPlot({
    datos() %>%
      st_drop_geometry() %>%
      select(luz_electrica:sala_computacion) %>%
      pivot_longer(everything()) %>%
      count(name, value) %>%
      filter(!is.na(value)) %>%
      ggplot() +
      geom_col(aes(name, n, fill = value), position = "fill") +
      scale_x_discrete(guide = guide_axis(angle = 45)) +
      scale_y_continuous(labels = label_percent()) +
      scale_fill_brewer() +
      labs(x = NULL, y = NULL) +
      theme_minimal()
  })

  output$poblacionPlot <- renderText({
    datos() %>%
      pull(pob) %>%
      sum(na.rm = T)
  })
}
