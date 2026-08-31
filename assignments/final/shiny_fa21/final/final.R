library(tidyverse)
library(shiny)

d = read_csv('who_covid.csv')

# get variable names
variables_names = names(d)

# get names of numeric variables
variables_numeric = d %>% select_if(is.numeric) %>% names

# get names of categorical variables
variables_category = d %>% select_if(is.character) %>% names


d2 = read_csv('vaccine_data_us_timeline.csv')

# get variable names
variables_names2 = names(d)

# get names of numeric variables
variables_numeric2 = d %>% select_if(is.numeric) %>% names

# get names of categorical variables
variables_category2 = d %>% select_if(is.character) %>% names

ui <- navbarPage("Son Nguyen",
                 tabPanel("Covid19 Data by Countries",
                          
                          sidebarLayout(
                            sidebarPanel(
                              
                              selectInput(
                                inputId ="var1",
                                label = "Select a statistics",
                                choices = variables_numeric, selected = "Cumulative_cases"
                              ),
                              
                              checkboxGroupInput(inputId = "selected_country", label = "Select Country",
                                                 choices = c('United States of America','Viet Nam','The United Kingdom'), inline = TRUE),
                              
                              dateRangeInput(inputId = "date", 
                                             strong("Date range"), 
                                             start = "2020-01-01", end = "2021-11-25",
                                             min = "2020-01-01", max = "2021-11-25"),
                            ),
                            
                            
                            mainPanel(
                              plotOutput(outputId = 'show_plot')
                            )
                          )
                 ),
                 
                 
                 tabPanel("Covid Vaccines US",
                          
                          sidebarLayout(
                            sidebarPanel(
                              
                              selectInput(
                                inputId ="var2",
                                label = "Select a Categorical Variables",
                                choices = variables_numeric2, selected = "Doses_admin"
                              ),
                              
                              sliderInput(inputId = "fare",
                                          "Select Date Range:",
                                          min = min(d2$Doses_shipped, na.rm=TRUE),
                                          max = max(d2$Doses_shipped, na.rm=TRUE),
                                          value= c(50, 200)
                              
                            ),
                            
                              
                            ),
                            
                            mainPanel(
                              plotOutput(outputId = 'show_plot2')
                            )
                          )
                 )
)

# server is a function! 
server <- function(input, output) {
  
  
  output$show_plot <- renderPlot({
    d = read_csv('who_covid.csv')
    v1 = input$var1
    v2 = input$var2
    country = input$selected_country
    print(v1)
    library(ggplot2)
    
    d <- d %>% filter(Country %in% country, Date_reported>input$date[1],  Date_reported<input$date[2]) 
    
    r <- d %>% ggplot(aes(x = Date_reported, y = d[[v1]], color = Country))+
      geom_point()+
      labs(x = 'Date', y = v1)
    
    return(r)
    
    
  })
  
  
  output$show_plot2 <- renderPlot({
    
    v2 = input$var2
    
    library(ggplot2)
    
    ggplot(d, aes(x = d[[v2]]))+
      geom_bar()+
      labs(x = v2)
    
    
  })
  
}
# app
shinyApp(ui = ui, server = server)