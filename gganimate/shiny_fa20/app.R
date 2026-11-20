library(shiny)

######################################
# Set User Interface
ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput(
        "var1",
        label = "Decide a number",
        min = 1,
        max = 100,
        value=10
      )
      
    ),
    
    mainPanel(
      # Output: Histogram ----
      plotOutput(outputId = 'blah1')
    )
    
  )
  
)


######################################
# Set up the server
server <- function(input, output) {
  
  output$blah1 <-renderPlot({
    m = input$var1
    hist(rnorm(mean=m, n=1000))
  }
  )
  
  
}

######################################
# Run the app
shinyApp(ui = ui, server = server)
