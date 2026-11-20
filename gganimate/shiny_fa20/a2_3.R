library(tidyverse)
library(shiny)

d = read_csv('titanic.csv')
# drop some columns
d <- d %>% select(-Name, -PassengerId, -Ticket)

# convert categorical variables to character type
d <- d %>% mutate_at(c('Survived', 'Pclass'), as.character)

# get variable names
variables_names = names(d)

# get names of numeric variables
variables_numeric = d %>% select_if(is.numeric) %>% names

# get names of categorical variables
variables_category = d %>% select_if(is.character) %>% names



ui <- fluidPage(
  
  titlePanel("Density Plot for Titanic Data"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        inputId ="var1",
        label = "Select a Numeric Variables",
        choices = variables_numeric, selected = "Age"
      ),
      
      selectInput(
        inputId ="var2",
        label = "Select a Categorical Variables",
        choices = variables_category,
        selected = "Sex"
      ),
      
      checkboxGroupInput(inputId = "embarked_location", label = "Select Embarked Location",
                         choices = names(table(d$Embarked)), inline = TRUE),
      
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