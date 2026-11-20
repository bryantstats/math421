library(tidyverse)
library(shiny)

d = read_csv('titanic.csv')
variables_names = names(d)

#######################################
ui <- fluidPage(
  
  titlePanel("Density Plot for Titanic"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        inputId ="var1",
        label = "Select a Numeric Variables",
        choices = variables_names, 
        selected = 'Age'
      ), 
      
      selectInput(
        inputId ="var2",
        label = "Select a Categorical Variables",
        choices = variables_names, 
        selected = 'Pclass'
      ),
      
      checkboxGroupInput(inputId = "embarked_location", 
                         label = "Select Embarked Location",
                         choices = names(table(d$Embarked)), 
                         selected = 'S',
                         inline = TRUE)
      
      
      
    ),
    
    
    mainPanel(
      
      plotOutput(outputId = 'show_plot')
      
    )
  )
)

#######################################
server <- function(input, output) {
  
  output$show_plot <- renderPlot({
    
    v1 = input$var1
    v2 = input$var2
    
    library(ggplot2)
    
    d <- d %>% filter(Embarked %in% input$embarked_location)
    
    ggplot(d, aes(x = d[[v1]], color = as.factor(d[[v2]])))+
      geom_density()+
      labs(x = v1, color = v2)
    
    
  })
  
}


#######################################
shinyApp(ui = ui, server = server)