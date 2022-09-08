



models = c('ranger', 'rpart', 'glmnet', 'rpart2', 'gbm')

ui <- fluidPage(
  
  titlePanel("Covid 19 by States"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      fileInput('f1', label = 'Upload data for visualization', accept = '.csv'),
      
      checkboxGroupInput(inputId = "mod", label = "Select models to compare",
                         choices = models, inline = TRUE),
      
      
      selectInput(inputId ='target_variable', label='Select target Variable', choices = ''),
      
      checkboxGroupInput(inputId = "input_variables", label = "Select input variables",
                         inline = TRUE, choices = ''),
      
    ),
  
    mainPanel(
      
      imageOutput(outputId = 'show_plot')
    )
  )
)

# server is a function! 
server <- function(input, output, session) {
  library(shiny)
  
  myData <- reactive({
    inFile = input$f1
    if (is.null(inFile)) return(NULL)
    data <- read_csv(inFile$datapath)
    data
  }
  )
  
  output$show_plot <- renderPlot({
    
    library(tidyverse)
    library(ggplot2)
    library(caret)
    
    mod = input$mod
    
    
    inFile = input$f1

    d <- read_csv(inFile$datapath)
    
    d <- as_tibble(d)
    
    d <- d %>% select(input$target_variable, input$input_variables)
    
    d <- drop_na(d)
    
    names(d)[1] <- 'target'
    
    d$target <- as.factor(d$target)
    
    model_list = list()
    
    for (i in 1:length(mod))
    {
      set.seed(2020)
      model_list[[i]] <- train(target~., data=d, 
                      method = mod[i])
    }
    
    names(model_list) = mod
    results <- resamples(model_list)
    bwplot(results)
  }    
)
  
  
  observeEvent(input$f1,{ 
    inFile = input$f1
    data <- read_csv(inFile$datapath)   
    updateSelectInput(session, 'target_variable', choices = names(data))}
  )
  
  observeEvent(input$f1,{ 
    inFile = input$f1
    data <- read_csv(inFile$datapath)
    choices = as.list(c(1:ncol(data)))
    updateCheckboxGroupInput(session, 'input_variables', choices = names(data))}
  )
  
  
}

shinyApp(ui = ui, server = server)