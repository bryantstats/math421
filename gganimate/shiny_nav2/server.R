library(tidyverse)
library(shiny)


server <- function(input, output) {
  
  # server is a function! 
  
  output$show_plot <- renderPlot({
    
    v1 = input$var1
    
    library(ggplot2)
    
      ggplot(d, aes(x = d[[v1]]))+
        geom_density()+
        labs(x = v1)
    
    
  })
  
  output$show_plot2 <- renderPlot({
    
    v2 = input$var2
    
    library(ggplot2)
    
    ggplot(d, aes(x = d[[v2]]))+
      geom_bar()+
      labs(x = v2)
    
    
  })
  
}
# app

shinyApp(ui = ui, server = server)