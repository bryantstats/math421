
####################### MODEL TUNING
library(tidyverse)
library(tidymodels)


titanic_train <- read_csv('https://bryantstats.github.io/math421/data/titanic.csv')
library(tidymodels)

# Setup the model
tune_spec <- 
  rand_forest(
    mtry = tune(),
    trees  = tune(),
    min_n = tune()
  ) %>% 
  set_engine("ranger") %>% 
  set_mode("classification")


# preprocessing
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


doParallel::registerDoParallel()

# Train + Tune
tree_res <- 
  workflow() %>% 
  add_recipe(titanic_recipe) %>% 
  add_model(tune_spec) %>% 
  tune_grid(
    resamples = vfold_cv(titanic_train),
    grid = crossing(
      mtry = 3:5,
      trees  = seq(100, 200, 50),
      min_n  = seq(100, 300, 50)
    )
  )

# Plot the result
autoplot(tree_res)

tree_res %>% 
  collect_metrics()

tree_res %>%
  select_best("accuracy")

########################################### MODEL COMPARISON

library(tidyverse)
library(tidymodels)


titanic_train <- read_csv('https://bryantstats.github.io/math421/data/titanic.csv')
library(tidymodels)




# preprocessing
titanic_recipe1 <- 
  recipe(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, 
         data = titanic_train) %>% # keep variables we want
  step_impute_median(Age,Fare) %>% # imputation
  step_impute_mode(Embarked) %>% # imputation
  step_mutate_at(Survived, Pclass, Sex, Embarked, fn = factor) %>% # make these factors
  step_mutate(Travelers = SibSp + Parch + 1) %>% # new variable
  step_rm(SibSp, Parch) %>% # remove variables
  step_dummy(all_nominal_predictors()) # create indicator variables
  
  # preprocessing
  titanic_recipe2 <- 
  recipe(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, 
         data = titanic_train) %>% # keep variables we want
  step_impute_mean(Age,Fare) %>% # imputation
  step_impute_mode(Embarked) %>% # imputation
  step_mutate_at(Survived, Pclass, Sex, Embarked, fn = factor) %>% # make these factors
  step_mutate(Travelers = SibSp + Parch + 1) %>% # new variable
  step_rm(SibSp, Parch) %>% # remove variables
  step_dummy(all_nominal_predictors())  # create indicator variables


  
  # preprocessing
  titanic_recipe3 <- 
  recipe(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, 
         data = titanic_train) %>% # keep variables we want
  step_impute_median(Age,Fare) %>% # imputation
  step_impute_mode(Embarked) %>% # imputation
  step_mutate_at(Survived, Pclass, Sex, Embarked, fn = factor) %>% # make these factors
  step_mutate(Travelers = SibSp + Parch + 1) %>% # new variable
  step_rm(SibSp, Parch) %>% # remove variables
  step_dummy(all_nominal_predictors()) %>% # create indicator variables
  step_normalize(all_numeric_predictors()) # normalize numerical variables


# Setup the model
model1 <- 
  rand_forest(
    mtry = tune(),
    trees  = tune(),
    min_n = tune()) %>% 
  set_engine("ranger") %>% 
  set_mode("classification")

model2 <-
  decision_tree(
    cost_complexity = tune(),
    tree_depth = tune()) %>% 
  set_engine("rpart") %>% 
  set_mode("classification")



models_list <- 
  list(model1 = model1, 
       model2 = model2)

all_workflows <- workflow_set(
  preproc = list(titanic_recipe1, titanic_recipe2, titanic_recipe3 ),
  models = models_list) %>% 
  workflow_map(resamples = bootstraps(titanic_train), grid = 10, verbose = TRUE)

rank_results(all_workflows, rank_metric = "roc_auc")


autoplot(all_workflows, metric = "roc_auc")

########################################### 

























library(tidyverse)
library(tidymodels)


titanic_train <- read_csv('https://bryantstats.github.io/math421/data/titanic.csv')
library(tidymodels)
set.seed(2022)
titanic_folds <- bootstraps(data = titanic_train, 
                            times = 25)


titanic_rf_spec <-  
  rand_forest(trees = 1000) %>% # algorithm speicfic argument:1000 trees
  set_engine('ranger') %>% 
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


doParallel::registerDoParallel()
titanic_rf_wf <- 
  workflow() %>% 
  add_recipe(titanic_recipe) %>% 
  add_model(titanic_rf_spec) %>% 
  fit_resamples(titanic_folds)



collect_metrics(titanic_rf_wf)



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

# https://rpubs.com/tsadigov/titanic_tidymodels

#######################
library(tidyverse)
library(tidymodels)


titanic_train <- read_csv('https://bryantstats.github.io/math421/data/titanic.csv')
library(tidymodels)
set.seed(2022)
titanic_folds <- bootstraps(data = titanic_train, 
                            times = 25)


tune_spec <- 
  decision_tree(
    cost_complexity = tune(),
    tree_depth = tune()
  ) %>% 
  set_engine("rpart") %>% 
  set_mode("classification")


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


doParallel::registerDoParallel()

tree_res <- 
  workflow() %>% 
  add_recipe(titanic_recipe) %>% 
  add_model(tune_spec) %>% 
  tune_grid(
    resamples = vfold_cv(titanic_train),
    grid = grid_regular(cost_complexity(),
                        tree_depth(),
                        levels = 3)
  )


tree_res %>% 
  collect_metrics()

tree_res %>%
  collect_metrics() %>%
  mutate(tree_depth = factor(tree_depth)) %>%
  ggplot(aes(cost_complexity, mean, color = tree_depth)) +
  geom_line(size = 1.5, alpha = 0.6) +
  geom_point(size = 2) +
  facet_wrap(~ .metric, scales = "free", nrow = 2) +
  scale_x_log10(labels = scales::label_number()) +
  scale_color_viridis_d(option = "plasma", begin = .9, end = 0)


tree_res %>%
  select_best("accuracy")































##################
# Second Example

library(tidymodels)
library(readr)

hotels <- 
  read_csv('https://tidymodels.org/start/case-study/hotels.csv') %>%
  mutate(across(where(is.character), as.factor))

set.seed(123)
splits      <- initial_split(hotels, strata = children)

hotel_other <- training(splits)
hotel_test  <- testing(splits)

set.seed(234)
val_set <- validation_split(hotel_other, 
                            strata = children, 
                            prop = 0.80)


lr_mod <- 
  logistic_reg(penalty = tune(), mixture = 1) %>% 
  set_engine("glmnet")

holidays <- c("AllSouls", "AshWednesday", "ChristmasEve", "Easter", 
              "ChristmasDay", "GoodFriday", "NewYearsDay", "PalmSunday")

lr_recipe <- 
  recipe(children ~ ., data = hotel_other) %>% 
  step_date(arrival_date) %>% 
  step_holiday(arrival_date, holidays = holidays) %>% 
  step_rm(arrival_date) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_predictors())


lr_workflow <- 
  workflow() %>% 
  add_model(lr_mod) %>% 
  add_recipe(lr_recipe)

lr_reg_grid <- tibble(penalty = 10^seq(-4, -1, length.out = 30))

lr_res <- 
  lr_workflow %>% 
  tune_grid(val_set,
            grid = lr_reg_grid,
            control = control_grid(save_pred = TRUE),
            metrics = metric_set(roc_auc))


lr_plot <- 
  lr_res %>% 
  collect_metrics() %>% 
  ggplot(aes(x = penalty, y = mean)) + 
  geom_point() + 
  geom_line() + 
  ylab("Area under the ROC Curve") +
  scale_x_log10(labels = scales::label_number())

lr_plot 

top_models <-
  lr_res %>% 
  show_best("roc_auc", n = 15) %>% 
  arrange(penalty) 
top_models

lr_best <- 
  lr_res %>% 
  collect_metrics() %>% 
  arrange(penalty) %>% 
  slice(12)
lr_best


lr_auc <- 
  lr_res %>% 
  collect_predictions(parameters = lr_best) %>% 
  roc_curve(children, .pred_children) %>% 
  mutate(model = "Logistic Regression")

autoplot(lr_auc)












######################

cores <- parallel::detectCores()
cores


rf_mod <- 
  rand_forest(mtry = tune(), min_n = tune(), trees = 1000) %>% 
  set_engine("ranger", num.threads = cores) %>% 
  set_mode("classification")

rf_recipe <- 
  recipe(children ~ ., data = hotel_other) %>% 
  step_date(arrival_date) %>% 
  step_holiday(arrival_date) %>% 
  step_rm(arrival_date) 

rf_workflow <- 
  workflow() %>% 
  add_model(rf_mod) %>% 
  add_recipe(rf_recipe)


set.seed(345)
rf_res <- 
  rf_workflow %>% 
  tune_grid(val_set,
            grid = 25,
            control = control_grid(save_pred = TRUE),
            metrics = metric_set(roc_auc))

