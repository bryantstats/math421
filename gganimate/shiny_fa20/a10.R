

library(tidyverse)
library(shiny)

d <- read_csv('titanic.csv')

d <- d %>% select(Survived, Pclass, Sex, Age)

d$Pclass <- factor(d$Pclass)
d$Sex <- factor(d$Sex)
d$Survived <- factor(d$Survived)

d <- drop_na(d)

models = c('ranger', 'rpart', 'glmnet', 'rpart2', 'gbm')

variables_names = names(d)

ui <- fluidPage(
  
  titlePanel("Modeling for Titanic"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      checkboxGroupInput(inputId = "mod", label = "Select models to compare",
                         choices = models, inline = TRUE),
      
      
      selectInput(inputId ='target_variable', label='Select target Variable', choices=variables_names),
      
      checkboxGroupInput(inputId = "input_variables", label = "Select input variables",
                         choices = variables_names, inline = TRUE),
      
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
    library(caret)
    
    mod = input$mod
    
    d <- d %>% select(input$target_variable, input$input_variables)
    
    names(d)[1] <- 'target'
    
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
  
  
}

shinyApp(ui = ui, server = server)