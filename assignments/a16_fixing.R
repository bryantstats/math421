mode_impute <- function(x)
{
  if(!is.numeric(x))
  {
    # Find the mode of x
    mode_of_x <- names(sort(-table(x)))[1]
    # Replace the missing by the mode
    library(tidyr)
    x <- replace_na(x, mode_of_x) 
  }
  return(x)    
}

library(tidyverse)
df <- read_csv('titanic.csv')
x1 <- mode_impute(df$Embarked)
sum(is.na(x1))

categorical_impute <- function(d)
{
  for (i in 1:length(d))
  {
    d[[i]] <- mode_impute(d[[i]])
  }
  return(d)
}
