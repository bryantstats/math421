library(haven)
library(tidyverse)
d <- read_sas('hdd0318cy.sas7bdat')

d <- d %>% filter(yod==18)

df <- d %>% select(c("yod", "payfix","pay_ub92","age",  
                      "sex","raceethn","provider","moa", 
                      "yoa","mod","admtype", "asource" , 
                      "preopday" ,"los", "service" , "icu","ccu",    
                      "dispub92", "payer"  ,"drg","trandb", 
                      "randbg","randbs","orr", "anes","seq",   
                      "lab","dtest", "ther","blood","phar", 
                      "other","patcon","bwght","total","tot" ,  
                      "ecodub92","b_wt","pt_state","diag_adm","ancilar" ,
                      "campus","er_fee","er_chrg","er_mode","obs_chrg",
                      "obs_hour","psycchrg","nicu_day"))

df$target <- factor((df$tot>median(df$tot))^2)

df <- df %>% select(c("age",  "sex",      "raceethn", "provider", "moa",      
                      "mod",      "admtype",  "campus", 
                      "er_mode", 'target','los'))


df$sex=factor(df$sex)
df$raceethn=factor(df$raceethn)
df$provider=factor(df$provider)
df$moa=factor(df$moa)
df$mod=factor(df$mod)
df$admtype=factor(df$admtype)
df$campus=factor(df$campus)
df$er_mode=factor(df$er_mode)

df <- df[sample(1:dim(df)[1], 10000), ]

library(caret)
set.seed(00000)
splitIndex <- createDataPartition(df$target, p = .50, 
                                  list = FALSE)
df_train <- df[ splitIndex,]
df_test <- df[-splitIndex,]

library(rpart)
tree1<-rpart(target ~ ., 
             data = df_train)

# Plot the tree
library(rattle)
fancyRpartPlot(tree1)

pred <- predict(tree1, df_test, type = 'class')

cm <- confusionMatrix(data = pred, reference = df_test$target, positive = "1")

cm$overall[1]

#####################
trControl = trainControl(method = "cv",
                         number = 5)

tuneGrid = expand.grid(mtry = 2:4,
                       splitrule = c('gini', 'extratrees'),
                       min.node.size = c(1:10))

# Do approach 3 
ranger_cv <- train(target~., data=df_train, 
                   method = "ranger", 
                   trControl = trControl,
                   tuneGrid = tuneGrid)

pred <- predict(ranger_cv, df_test)

cm <- confusionMatrix(data = pred, reference = df_test$target, positive = "1")

cm$overall[1]
