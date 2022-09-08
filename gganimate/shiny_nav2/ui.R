library(tidyverse)
library(shiny)

d = read_csv('titanic.csv')

variables_names = names(d)

navbarPage("Navbar!",
           tabPanel("Plot1",
                    
                    sidebarLayout(
                      sidebarPanel(
                        
                        selectInput(
                          inputId ="var1",
                          label = "Select a Numeric Variables",
                          choices = variables_names, selected = "Age"
                        )
                      ),
                      
                      mainPanel(
                        plotOutput(outputId = 'show_plot')
                      )
                    )
           ),
           
           
           tabPanel("Plot2",
                    
                    sidebarLayout(
                      sidebarPanel(
                        
                        selectInput(
                          inputId ="var2",
                          label = "Select a Numeric Variables",
                          choices = variables_names, selected = "Sex"
                        )
                      ),
                      
                      mainPanel(
                        plotOutput(outputId = 'show_plot2')
                      )
                    )
           )
)

