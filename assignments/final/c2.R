library(tidyverse)
library(shiny)

d = read_csv('titanic.csv')

mylist = names(d)

ui <- fluidPage(
  
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      selectInput(
        inputId ="var1",
        label = "Select Variables",
        choices = mylist, selected = "Age"
      ),
      
      selectInput(
        inputId ="var2",
        label = "Select Variables",
        choices = mylist, 
        selected ="Fare"
      ),
      
      selectInput(
        inputId ="var3",
        label = "Select Variables",
        choices = mylist,
        selected = "Sex"
      ), 
      
      selectInput(
        inputId ="type",
        label = "Select Plot Type",
        choices = c('Scatter','Density','Boxplot'),
        selected = 'Scatter'
      )
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      
      plotOutput(outputId = 'blah1')
    )
  )
)

# server
server <- function(input, output) {
  
  
  output$blah1 <- renderPlot({
    library(plotly)
    d = read_csv('titanic.csv')
    v1 = input$var1
    v2 = input$var2
    v3 = input$var3
    t =  input$type
    
    if(t=='Scatter'){
      library(ggplot2)
      r = ggplot(d, aes(x = d[[v1]], y = d[[v2]], color = as.factor(d[[v3]])))+
        geom_point()+
        labs(x = v1, y = v2, color = v3)
      
    }
    
    if(t=='Density'){
      library(ggplot2)
      library(gridExtra)
      r1 = ggplot(d, aes(x = d[[v1]], color = as.factor(d[[v3]])))+
        geom_density()+
        labs(x = v1, color = v3)
      
      r2 = ggplot(d, aes(x = d[[v2]], color = as.factor(d[[v3]])))+
        geom_density()+
        labs(x = v2, color = v3)
      
      r = grid.arrange(r1, r2, nrow = 2)
      
      
    }
    
    if(t=='Boxplot'){
      library(ggplot2)
      library(gridExtra)
      r1 = ggplot(d, aes(y = d[[v1]], color = as.factor(d[[v3]])))+
        geom_boxplot()+
        labs(y = v1, color = v3)
      
      r2 = ggplot(d, aes(y = d[[v2]], color = as.factor(d[[v3]])))+
        geom_boxplot()+
        labs(y = v2, color = v3)
      
      r = grid.arrange(r1, r2, nrow = 2)
      
      
    }
    
    #return(ggplotly(r))
    return(r)
    
    
  })
  
}
# app
shinyApp(ui = ui, server = server)