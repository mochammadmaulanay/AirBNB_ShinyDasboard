function(input, output) {
    # Home
    output$logo <- renderImage({
        list(src = "www/airbnb_logo.png",
             alt = "Airbnb Logo",
             width = "100%")
    }, deleteFile = F)
    
    
    # Bar Plot
    
    ## Bar Data
    bar_df <- reactive({
        ab_nyc %>%
            filter(borough %in% c(input$borough),
                   room_type == input$room_type,
                   price <= input$price) %>% 
            slice_max(number_of_reviews, n = {input$top_n}) %>% 
            droplevels()
    })
    
    
    ## Top result
    output$top_listing <- renderText({
        bar_df()$name[1]
    })
    
    
    ## Bar Plot
    output$bar_plot <- renderPlotly({
        
        bar_plot <- bar_df() %>%
            ggplot(mapping = aes(x = reorder(name, number_of_reviews),
                                 y = number_of_reviews,
                                 text = glue("{name}
                                 Location: {neighbourhood}, {borough}
                                 Price: {dollar(price)}
                                 Reviews Count: {number_of_reviews}"))) +
            geom_col(fill = "#2c3e50") +
            geom_text(aes(label = number_of_reviews,
                          y = number_of_reviews + 12),
                      size = 3,
                      col = "black") +
            labs(title = glue("Top {input$top_n} {input$room_type} Listing under {dollar(input$price)} in {paste(input$borough, collapse = ', ')}"),
                 x = NULL,
                 y = "Number of Reviews") +
            scale_x_discrete(labels = wrap_format(20)) +
            coord_flip() +
            theme_classic() +
            theme(plot.title = element_text(hjust = 0.5))
        
        ggplotly(bar_plot, tooltip = "text") %>% 
            layout(hoverlabel = list(bgcolor = "b5e2ff"))
    })
    
    
    ## Value Boxes
    
    output$location <- renderValueBox({
        valueBox(
            glue("{bar_df()$neighbourhood[1]}, {bar_df()$borough[1]}"), "Location", icon = icon("search-location"),
            color = "blue"
        )
    })
    
    output$reviews <- renderValueBox({
        valueBox(
            {bar_df()$number_of_reviews[1]}, "Number of Reviews", icon = icon("star"),
            color = "blue"
        )
    })
    
    output$price <- renderValueBox({
        valueBox(
            glue("${bar_df()$price[1]}"), "Listing Price", icon = icon("money-check-alt"),
            color = "blue"
        )
    })
        
    
    # Data
    output$dataframe <- renderDataTable({
        datatable(ab_nyc, 
                  options = list(scrollX = T))
    })
        
    # Map
    output$map <- renderLeaflet({
        
        bnb_icon <- makeIcon(
            iconUrl = "www/home.png",
            iconWidth = 30, 
            iconHeight = 30
        )
        
        popup <- paste(sep = "",
                       ab_nyc$name, "<br>",
                       "Room Type: ", ab_nyc$room_type, "<br>",
                       "Price: ", dollar(ab_nyc$price),"<br>",
                       "Number of Reviews: ", ab_nyc$number_of_reviews
        )
        
        leaflet(options = leafletOptions(zoomControl = FALSE,
                                         minZoom = 10)) %>%
            setView(lng = -73.935242, lat = 40.730610, zoom = 10) %>%
            
            addTiles() %>% 
            
            addMarkers(lat = ab_nyc$latitude,
                       lng = ab_nyc$longitude,
                       icon = bnb_icon,
                       popup = popup,
                       clusterOptions = markerClusterOptions()
            ) %>%
            
            addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
            
            addProviderTiles(providers$Stamen.TonerLines,
                             options = providerTileOptions(opacity = 0.5)) %>%
            
            addProviderTiles(providers$Stamen.TonerLabels) %>% 
            addProviderTiles(providers$OpenSeaMap)
    })
}