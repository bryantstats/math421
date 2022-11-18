library(tidyverse)
library(shiny)
library(DT)

ui <- fluidPage(
  
  titlePanel("Model"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      fileInput('f1', label = 'Upload data', accept = '.csv'),
      
      selectInput('y', label='Select target variable', choices=c('')),
      
      checkboxGroupInput("x", label = "Select input variables"),
      
      sliderInput('depth', label = 'Decide the max depth', min = 1, max = 5, value = 1)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      plotOutput(outputId = 'tree')
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
    
  output$tree <- renderPlot({
  
    inFile = input$f1
    d <- read_csv(inFile$datapath)
    v1 = input$y
    v2 = as.numeric(input$x)
    d = cbind(d[,v1], d[,v2])
    names(d)[1]='target'
    print(v2)
    max_depth = input$depth
    library(rpart)
    library(rattle)
    set.seed(2019)
    mytree2 <- rpart(target ~., data = d, method = "class", control = rpart.control(maxdepth = max_depth))
    fancyRpartPlot(mytree2)
    
  })
  
  
  observeEvent(input$f1,{ 
    inFile = input$f1
    data <- read.csv(inFile$datapath, header = TRUE)   
               updateSelectInput(session, 'y', choices = names(data))}
               )
  
  observeEvent(input$f1,{ 
    inFile = input$f1
    data <- read.csv(inFile$datapath, header = TRUE)
    choices = as.list(c(1:ncol(data)))
    names(choices)= names(data)
    updateCheckboxGroupInput(session, 'x', choices = choices)}
  )
  
}
# app
shinyApp(ui = ui, server = server)

# deployApp()
