


library(tidyverse)
library(shiny)

d <- read_csv('https://covidtracking.com/data/download/all-states-history.csv')

write.csv(d, 'covid19.csv', row.names = FALSE)

preselected_states = c('CA', 'FL', 'TX', 'MA', 'NY', 'OH')

variables_names = names(d)

first_date = min(d$date)

current_date = max(d$date)
                     

ui <- fluidPage(
  
  titlePanel("Covid 19 by States"),

  sidebarLayout(
    
    sidebarPanel(
      
      checkboxGroupInput(inputId = "x", 
                         label = h3("Select state to compare"),
                         choices = preselected_states, 
                         selected = 'CA',
                         inline = TRUE),
      
      
      selectInput(inputId ='v1', 
                  label=h3('Select a Numeric Variable'),
                  choices=variables_names,
                  selected = 'positive'),
      
      sliderInput(inputId = "date",
                  label = h3("Select Date Range:"),
                  min = first_date,
                  max = current_date,
                  value= c(first_date, current_date),
                  timeFormat="%d %b"),
      
      radioButtons(inputId = "plot_choice", 
                   label = h3("Select Plot:"),
                   choices = c("Line Plot" = "line",
                               "Point Plot" = "point"),
                   selected = 'line'),
      
    ),
  
    mainPanel(
      
      imageOutput(outputId = 'show_plot')
    )
  )
)

# server is a function! 
server <- function(input, output) {
  
  output$show_plot <- renderPlot({
    
    library(tidyverse)
    library(ggplot2)
    library(gganimate)
    
    v1 = input$v1
    
    d <- d %>% 
      filter(state %in% input$x, date>input$date[1], date<input$date[2])
    
    if(input$plot_choice == 'line')
    {
      ggplot(d, aes_string(y=v1,
                           x='date',
                           color='state'))+ 
        geom_line()  
    }
    
    else{
      ggplot(d, aes_string(y=v1,
                           x='date',
                           color='state'))+ 
        geom_point()
    }
    
  }    
)
  
  
}

shinyApp(ui = ui, server = server)