library(tidyverse)
df = read_csv("titanic.csv")

# Set the target variable
names(df)[8] <- 'target'

# Remove some columns
df$PassengerId =  NULL
df$Ticket =  NULL
df$Name = NULL
df$Cabin = NULL

# Correct variables' types
df$target <- factor(df$target)
df$Pclass = factor(df$Pclass)
df$Sex <- factor(df$Sex)
df$Embarked <- factor(df$Embarked)

# Handle missing values
df$Age[is.na(df$Age)] = mean(df$Age, na.rm = TRUE)

df = drop_na(df)

# Split the data to train and test
library(caret)
set.seed(2020)
splitIndex <- createDataPartition(df$target, p = .70, 
                                  list = FALSE)
df_train <- df[ splitIndex,]
df_test <- df[-splitIndex,]

library(rpart) #load the rpart package

# Create a tree
tree_model <- rpart(target ~ ., data = df_train,
                    control = rpart.control(maxdepth = 3))


# Plot the tree

library(rattle)
fancyRpartPlot(tree_model)


# Variable importances
tree_model$variable.importance

# Variable importances
barplot(tree_model$variable.importance)

#predict on testing data
pred <- predict(tree_model, df_test, type = "class")

#Evaluate the predictions
cm <- confusionMatrix(data = pred, reference = df_test$target, positive = "1")
cm$overall[1]

# Random Forest
library(randomForest)
forest_model = randomForest(target ~ ., data=df_train, ntree = 500)
pred <- predict(forest_model, df_test, type = "class")

cm <- confusionMatrix(data = pred, reference = df_test$target, positive = "1")

cm$overall[1]

# Variable importance
importance(forest_model)

# Create a Decision Tree with Caret
model1 <- train(target~., data=df_train, 
                method = "rpart2", #<<
                maxdepth=3)

pred <- predict(model1, df_test)

cm <- confusionMatrix(data = pred, reference = df_test$target, positive = "1")

cm$overall[1]

# Create a Random Forest with Caret
model2 <- train(target~., data=df_train, 
                method = "rf", #<< 
                ntree = 1000) 

pred <- predict(model2, df_test)

cm <- confusionMatrix(data = pred, reference = df_test$target, positive = "1")

cm$overall[1]

# Variable Importance
# Tree
varImp(model1)
# Forest
varImp(model2)

# Plot Variable Importance
# Tree
plot(varImp(model1)) 
# Forest
plot(varImp(model2)) 
