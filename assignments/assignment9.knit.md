---
title: "Assignment 9"
format: html
editor: visual
---


***How to do it?***: 

- Open the Rmarkdown file of this assignment ([link](assignment9.Rmd)) in Rstudio. 

- Right under each **question**, insert  a code chunk (you can use the hotkey `Ctrl + Alt + I` to add a code chunk) and code the solution for the question. 

- `Knit` the rmarkdown file (hotkey: `Ctrl + Alt + K`) to export an html.  

-  Publish the html file to your Githiub Page. 

***Submission***: Submit the link on Github of the assignment to Canvas






-------

**Notice:** *In this assignment, all the plot should have title, caption, and axis labels. *

1. Use the dataset by of covid 19 by WHO at https://covid19.who.int/WHO-COVID-19-global-data.csv. Find the three countries with the most numbers of deaths by Covid-19. 

Hint: 

-  Use `filter` to select the most current date 

-  Pipe with `arrange(-Cumulative_deaths)` to rank the data by the number of cumulative deaths


2. Use `transition_reveal` to make a plot revealing the number of deaths in the three countries with the most numbers of deaths

3. Create the new variable (column) `death_per_cases` recording the number of deaths per cases (Hint: divide cumulative deaths by cumulative cases).  What are the three countries with the highest deaths per cases? 

4. Use `transition_reveal` to make a plot revealing the number of deaths per cases of the US, Italy and Mexico. 

5. Import the following data https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv
                      
Use `transition_reveal` to plot the total vaccinations per hundred by level of income. Hint: the levels of income are identified in the `location` variable. Put a short comment on the caption of the plot. 
