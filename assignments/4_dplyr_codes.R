library(tidyverse)
df <- read_csv("https://covidtracking.com/data/download/all-states-history.csv")

df %>% count(state) 

df %>% count(state) %>% arrange(n)

df %>% count(state) %>% arrange(-n)

df %>% summarise(mean_death_increase = mean(deathIncrease))

df %>% filter(state=='RI') %>% summarise(mean_death_increase = mean(deathIncrease))
