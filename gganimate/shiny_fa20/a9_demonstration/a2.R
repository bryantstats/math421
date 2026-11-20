library(tidyverse)
library(shiny)

d = read_csv('titanic.csv')

variables_names = names(d)


ui <- fluidPage(
  
  titlePanel("Density Plot"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        inputId ="var1",
        label = "Select a Numeric Variables",
        choices = variables_names, 
        selected = "Age"
      ),
      
      selectInput(
        inputId ="var2",
        label = "Select a Categorical Variables",
        choices = variables_names,
        selected = "Sex"
      ),
      
      checkboxGroupInput(inputId = "embarked_location", 
                         label = "Select Embarked Location",
                         choices = names(table(d$Embarked)), 
                         selected = 'S',
                         inline = TRUE),
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      
      plotOutput(outputId = 'show_plot')
    )
  )
)

# server is a function! 
server <- function(input, output) {
  
  
  output$show_plot <- renderPlot({
    
    v1 = input$var1
    v2 = input$var2
   
    d <- d %>% filter(Embarked %in% input$embarked_location)
    
    library(ggplot2)
    
      ggplot(d, aes(x = d[[v1]], color = as.factor(d[[v2]])))+
        geom_density()+
        labs(x = v1, color = v2)
    
    
  })
  
}
# app
shinyApp(ui = ui, server = server)