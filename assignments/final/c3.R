library(tidyverse)
library(shiny)
library(DT)

ui <- fluidPage(
  
  titlePanel("Visualization"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      fileInput('f1', label = 'Upload data for visualization', accept = '.csv'),
      
      selectInput('v1', label='Select Variable', choices=''),
      selectInput('v2', label='Select Variable', choices=''),
      selectInput('v3', label='Select Variable', choices=''),
      selectInput(
        "type",
        label = "Select Plot Type",
        choices = c('Scatter','Density','Boxplot'),
        selected = 'Scatter'
      )
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      dataTableOutput(outputId = 'show_table'),
      plotOutput(outputId = 'show_plot')
    )
  )
)

# server
server <- function(input, output, session) {
  
  myData <- reactive({
    inFile = input$f1
    if (is.null(inFile)) return(NULL)
    data <- read.csv(inFile$datapath, header = TRUE)
    data
  }
    )
    
  output$show_plot <- renderPlot({
  
    inFile = input$f1
    v1 = input$v1
    d <- read.csv(inFile$datapath, header = TRUE)
    
    v1 = input$v1
    v2 = input$v2
    v3 = input$v3
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
  
  
  observeEvent(input$f1,{ 
    inFile = input$f1
    data <- read.csv(inFile$datapath, header = TRUE)   
               updateSelectInput(session, 'v1', choices = names(data))}
               )
  
  observeEvent(input$f1,{ 
    inFile = input$f1
    data <- read.csv(inFile$datapath, header = TRUE)   
    updateSelectInput(session, 'v2', choices = names(data))}
  )
  
  observeEvent(input$f1,{ 
    inFile = input$f1
    data <- read.csv(inFile$datapath, header = TRUE)   
    updateSelectInput(session, 'v3', choices = names(data))}
  )
  
  
}
# app
shinyApp(ui = ui, server = server)

# deployApp()
