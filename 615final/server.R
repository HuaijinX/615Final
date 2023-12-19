#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output) {
  
  # Render the pre-defined leaflet Barbados map
  output$barbadosMap <- renderLeaflet({
    barbados_map
  })
  
  # Render the pre-defined ggplot world map
  output$ggplotWorldMap <- renderPlot({
    world_map_plot
  })
  output$ggplotGdp <- renderPlot({
    gdp_plot
  })
  output$populationPlot <- renderPlot({
    population_plot
  })
  output$piechartReligion <- renderPlot({  
    religion_plot
  })
  output$fertilityTable <- renderDataTable({
    decade_fertility
  })
  output$populationComparison <- renderPlot({
    population_comparison_plot
  })
  output$gdpComparison <- renderPlot({
    gdp_comparison_plot
  })
  output$fertilityComparison <-renderPlot({
    fertility_comparison_plot
  })
  output$areaPlot <- renderPlot({
    area_plot
  })
}
