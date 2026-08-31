####################### MODELing
library("mlr3")

library(tidyverse)
library(tidymodels)


titanic_train <- read_csv('https://bryantstats.github.io/math421/data/titanic.csv')

task_penguins = as_task_classif(Survived ~ Sex + Age + Pclass, data = titanic_train)


learner = lrn("classif.rpart", cp = .01)

# train/test split
split = partition(task_penguins, ratio = 0.67)

# train the model
learner$train(task_penguins, split$train_set)

# predict data
prediction = learner$predict(task_penguins, split$test_set)

# calculate performance
prediction$confusion

measure = msr("classif.acc")
prediction$score(measure)
