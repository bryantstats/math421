library(shiny)
library(tidyverse)

titanic <- read_csv("titanic.csv") |>
  mutate(Survived = factor(Survived, labels = c("No", "Yes")),
         Pclass   = factor(Pclass))

ui <- fluidPage(
  titlePanel("Titanic: Survival by Group"),
  sidebarLayout(
    sidebarPanel(
      selectInput("var", "Group by", choices = c("Sex", "Pclass", "Embarked"))
    ),
    mainPanel(
      plotOutput("bar")
    )
  )
)

server <- function(input, output) {
  output$bar <- renderPlot({
    ggplot(titanic, aes(x = .data[[input$var]], fill = Survived)) +
      geom_bar(position = "fill") +
      labs(y = "Proportion")
  })
}

shinyApp(ui, server)
