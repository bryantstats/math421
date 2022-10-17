library(tidyverse)
library(tidymodels)
library(xgboost)
library(reticulate)
library(dotwhisker)


train <- read_csv('https://bryantstats.github.io/math421/data/titanic.csv')
train <- train %>% select(-PassengerId, -Name, -Ticket, -Cabin, -Embarked)
train <- drop_na(train)
train$Survived <- factor(train$Survived)


data_split <- initial_split(train)
train_df <- training(data_split)  
data_test <- testing(data_split)


rf_mod <-
  rand_forest(mtry=tune(), trees=tune()) %>%
  set_engine('ranger') %>%
  set_mode('classification') %>% 
  fit(Survived ~ ., data = data_train)


rec <- 
  recipe(Survived ~ ., data=train_df) %>%
  step_zv(all_predictors()) %>%
  step_center(all_predictors(), -all_nominal()) %>%
  step_scale(all_predictors(), -all_nominal()) %>%
  prep()


summary(rec)

wflw <- 
  workflow() %>%
  add_model(rf_mod) %>%
  add_recipe(rec)


titanic_train <- read_csv('https://bryantstats.github.io/math421/data/titanic.csv')
library(tidymodels)
set.seed(2022)
titanic_folds <- bootstraps(data = titanic_train, 
                            times = 25)
titanic_folds

titanic_glm_spec <- 
  logistic_reg() %>% # model
  set_engine('glm') %>%  # package to use
  set_mode('classification') # choose one of two: classification vs regresson

titanic_rf_spec <-  
  rand_forest(trees = 1000) %>% # algorithm speicfic argument:1000 trees
  set_engine('ranger') %>% 
  set_mode('classification')

titanic_svm_spec <-  
  svm_rbf() %>% # rbf - radial based
  set_engine('kernlab') %>% 
  set_mode('classification')

# declare recipe
titanic_recipe <- 
  recipe(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, 
         data = titanic_train) %>% # keep variables we want
  step_impute_median(Age,Fare) %>% # imputation
  step_impute_mode(Embarked) %>% # imputation
  step_mutate_at(Survived, Pclass, Sex, Embarked, fn = factor) %>% # make these factors
  step_mutate(Travelers = SibSp + Parch + 1) %>% # new variable
  step_rm(SibSp, Parch) %>% # remove variables
  step_dummy(all_nominal_predictors()) %>% # create indicator variables
  step_normalize(all_numeric_predictors()) # normalize numerical variables

doParallel::registerDoParallel() # resample fitting is embarrasingly parrallel problem
titanic_glm_wf <- 
  workflow() %>% 
  add_recipe(titanic_recipe) %>% 
  add_model(titanic_glm_spec) %>% 
  fit_resamples(titanic_folds)
titanic_glm_wf

# random forest
doParallel::registerDoParallel()
titanic_rf_wf <- 
  workflow() %>% 
  add_recipe(titanic_recipe) %>% 
  add_model(titanic_rf_spec) %>% 
  fit_resamples(titanic_folds)
# svm
doParallel::registerDoParallel()
titanic_svm_wf <- 
  workflow() %>% 
  add_recipe(titanic_recipe) %>% 
  add_model(titanic_svm_spec) %>% 
  fit_resamples(titanic_folds)


titanic_rf_last_wf <- 
  workflow() %>% 
  add_recipe(titanic_recipe) %>% 
  add_model(titanic_rf_spec)
final_fit <- 
  fit(object = titanic_rf_last_wf, 
      data = titanic_train)
final_fit %>% 
  extract_recipe(estimated = T)

final_fit %>%
  extract_fit_parsnip()

