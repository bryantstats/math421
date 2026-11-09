library(shiny)
library(tidyverse)

titanic <- read_csv("titanic.csv") |>
  mutate(Survived = factor(Survived, labels = c("No", "Yes")),
         Pclass   = factor(Pclass))

ui <- navbarPage("Titanic Explorer",
  tabPanel("Plot",
    sidebarLayout(
      sidebarPanel(
        selectInput("var", "Group by", choices = c("Sex", "Pclass", "Embarked")),
        checkboxGroupInput("class", "Passenger class",
                           choices = c("1", "2", "3"), selected = c("1", "2", "3")),
        sliderInput("age", "Age", min = 0, max = 80, value = c(0, 80)),
        radioButtons("pos", "Bar type",
                     choices = c("Proportion" = "fill", "Count" = "stack"))
      ),
      mainPanel(
        plotOutput("bar"),
        textOutput("n")
      )
    )
  ),
  tabPanel("Data", tableOutput("tbl"))
)

server <- function(input, output) {
  # Filter once, reuse in every output
  filtered <- reactive({
    titanic |>
      filter(Pclass %in% input$class,
             Age >= input$age[1], Age <= input$age[2])
  })

  output$bar <- renderPlot({
    ggplot(filtered(), aes(x = .data[[input$var]], fill = Survived)) +
      geom_bar(position = input$pos) +
      labs(y = if (input$pos == "fill") "Proportion" else "Count")
  })

  output$n <- renderText(paste(nrow(filtered()), "passengers selected"))

  output$tbl <- renderTable({
    filtered() |> select(Name, Sex, Age, Pclass, Survived) |> head(20)
  })
}

shinyApp(ui, server)
