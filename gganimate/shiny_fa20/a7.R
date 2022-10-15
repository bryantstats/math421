library(tidyverse)
library(shiny)

d <- read_csv('https://covidtracking.com/data/download/all-states-history.csv')


choices = names(table(d$state))

variables_names = names(d)

ui <- fluidPage(
  
  titlePanel("Density Plot"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      checkboxGroupInput(inputId = "x", label = "Select state to compare",
                         choices = choices, inline = TRUE),
      
      
      selectInput(inputId ='v1', label='Select a Numeric Variable', choices=variables_names)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      
      verbatimTextOutput("print_text"),
      
      
      imageOutput(outputId = 'show_plot'),
      
      imageOutput(outputId = 'show_plot2')
    )
  )
)


ui <- navbarPage("Navbar!",
           tabPanel("Plot",
                    
                    fluidPage(
                      
                      titlePanel("Density Plot"),
                      
                      sidebarLayout(
                        
                        sidebarPanel(
                          
                          checkboxGroupInput(inputId = "x", label = "Select state to compare",
                                             choices = choices, inline = TRUE),
                          
                          
                          selectInput(inputId ='v1', label='Select a Numeric Variable', choices=variables_names)
                          
                        ),
                        
                        # Main panel for displaying outputs ----
                        mainPanel(
                          
                          # Output: Histogram ----
                          
                          verbatimTextOutput("print_text"),
                          
                          
                          imageOutput(outputId = 'show_plot'),
                          
                          imageOutput(outputId = 'show_plot2')
                        )
                      )
                    )
                    
                    
                    
                    
                    
                    ),
           tabPanel("Summary",
                    verbatimTextOutput("summary")
           )
)



# server is a function! 
server <- function(input, output) {
  
  output$print_text <- renderPrint({
    
    library(tidyverse)
    library(gganimate)
    # r <- d %>% 
    #   filter(state %in% choices[input$x]) %>% 
    #   ggplot(aes(y=positive,
    #              x=date,
    #              color=state))+ 
    #   geom_line()+
    #   geom_point(size=3)+
    #   geom_text(aes(label = positive), 
    #             hjust = -.1, size=5) +
    #   transition_reveal(date)
    
    print(class(input$v1))
    
    
  })
  
  
  output$show_plot <- renderPlot({
    
    library(tidyverse)
    library(ggplot2)
    library(gganimate)
    
    v1 = input$v1
    
    d <- d %>% 
      filter(state %in% input$x)
    
    ggplot(d, aes_string(y=v1,
                 x='date',
                 color='state'))+ 
      geom_line()
    
  }    
)
  
  output$show_plot2 <- renderPlot({
    
    library(tidyverse)
    library(ggplot2)
    library(gganimate)
    
    v1 = input$v1
    
    d <- d %>% 
      filter(state %in% input$x)
    
    ggplot(d, aes_string(y=v1,
                         x='date',
                         color='state'))+ 
      geom_line()
    
  }    
  )
  
  
}

shinyApp(ui = ui, server = server)