library(tidyverse)
df = read_csv("https://bryantstats.github.io/math421/data/titanic.csv")

# Remove some columns
df <- df %>% select(-PassengerId, -Ticket, -Name, -Cabin)


# Set the target variable
df <- df %>% rename(target=Survived)

# Correct variables' types
df <- df %>% 
  mutate(target = as.factor(target),
         Pclass = as.factor(Pclass),
  )


# Handle missing values
# Replace NA of Age by its mean
mean_age <- mean(df$Age, na.rm=TRUE)
df$Age <- replace_na(df$Age, mean_age)

df = drop_na(df)

library(caret)
set.seed(2020)
splitIndex <- createDataPartition(df$target, p = .70, 
                                  list = FALSE)
df_train <- df[ splitIndex,]
df_test <- df[-splitIndex,]

model1 <- train(target~., data=df_train, 
                method = "glmnet")

pred <- predict(model1, df_test)

cm <- confusionMatrix(data = pred, reference = df_test$target, positive = "1")

cm$overall[1]

# ---
  
# On Adult data

library(tidyverse)
library(caret)

df <- read_csv('https://bryantstats.github.io/math421/data/adult_census.csv')
df <- type.convert(df, as.is = FALSE)
df <- df %>% rename(target = income)
df <- df %>% filter(native.country=='Mexico')
df <- df %>% select(-native.country)


dmy <- dummyVars( ~ ., data = select(df, -target), fullRank = T)
dat_transformed <- tibble(data.frame(predict(dmy, newdata = select(df, -target))))
df <- tibble(cbind(df$target, dat_transformed))
names(df)[1] <- 'target'

set.seed(2020)
splitIndex <- createDataPartition(df$target, p = .70, 
                                  list = FALSE)
df_train <- df[ splitIndex,]
df_test <- df[-splitIndex,]  

model1 <- train(target~., data=df_train, 
                method = "glmnet")

pred <- predict(model1, df_test)

cm <- confusionMatrix(data = pred, reference = df_test$target, positive = ">50K")

cm$overall[1]
