library(tidyverse)
library(shiny)

d <- read_csv('https://covidtracking.com/data/download/all-states-history.csv')

write.csv(d, 'covid19.csv', row.names = FALSE)

preselected_states = c('CA', 'FL', 'TX', 'MA', 'NY', 'OH')

variables_names = names(d)

first_date = min(d$date)

current_date = max(d$date)


ui <- fluidPage(
  
  titlePanel("Title"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      checkboxGroupInput(inputId = "x", 
                         label = h3("Select state to compare"),
                         choices = preselected_states, 
                         selected = 'CA',
                         inline = TRUE)
      
      
      
    ),
    
    mainPanel(
      
      
      
      
    )
  )
)

# server is a function! 
server <- function(input, output) {
  
  
  
  
  
}

shinyApp(ui = ui, server = server)