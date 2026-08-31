library(shiny)
library(rattle)

# Read in the data
library(tidyverse)
titanic = read_csv("titanic.csv")

# Remove some columns
titanic$PassengerId =  NULL
titanic$Ticket =  NULL
titanic$Name = NULL
titanic$Cabin = NULL

# Correct variables' types
names(titanic)[1] = "target"  # change Survived to target
titanic$target = factor(titanic$target)
titanic$Pclass = factor(titanic$Pclass)

# Handle missing values

titanic$Age[is.na(titanic$Age)] = mean(titanic$Age, na.rm = TRUE)

# Model Building 

titanic = drop_na(titanic)

# Split 70% training, 30% testing
library(caret)
splitIndex <- createDataPartition(titanic$target, p = .70, list = FALSE, times = 1)
train <- titanic[ splitIndex,]
test <- titanic[-splitIndex,]

# 
library(rpart) #load the rpart package





######################################
ui <- fluidPage(
  
  titlePanel("Decision Tree for Titanic"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      sliderInput('depth','Max Depth', min = 1, max = 5, value = 1)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      

      plotOutput(outputId = 'blah1'),
      plotOutput(outputId = 'blah2')
    )
  )
)

############################################
server <- function(input, output) {
  
  output$blah1 <- renderPlot({
    max_depth = input$depth
    mytree2 <- rpart(target ~ ., data = train, method = "class", control = rpart.control(maxdepth = max_depth))
    fancyRpartPlot(mytree2)
  })
  

  
}
# app
shinyApp(ui = ui, server = server)

# deployApp()
