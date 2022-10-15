library(shiny)

######################################
# Set User Interface
ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput(
        inputId = "var1",
        label = "Decide the mean",
        min = 1,
        max = 100,
        value=10
      )
      
      ),
      
    mainPanel(
      # Output: Histogram ----
      plotOutput(outputId = 'show_plot')
    )
      
    )
    
  )
  

######################################
# Main codes for the app
server <- function(input, output) {
  
  output$show_plot <-renderPlot({
    m = input$var1
    hist(rnorm(mean=m, n=1000))
  }
  )

  
}

######################################
# Run the app
shinyApp(ui = ui, server = server)
