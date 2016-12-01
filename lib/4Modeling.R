rm(list = ls())
setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4")
load("input_data.RData")
load("outcome_label.RData")
install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
install.packages("xgboost", repos="http://dmlc.ml/drat/", type = "source")
require(xgboost)
library(xgboost)
X <- Input_Data
X[,1] <- as.numeric(X[,1])
X[,2] <- as.numeric(X[,2])
X[,3] <- as.numeric(X[,3])
X[,4] <- as.numeric(X[,4])
#X <- as.numeric(t(X))
Y <- outcome_label
#Y <- class(Y)
bstSparse <- xgboost(data = X, label = Y, max.depth = 2, eta = 1, nthread = 2, nround = 2, objective = "multi:softmax", num_class = 21)
length_data <- dim(Input_Data)[1]
index <- c(1:length_data)
testindex <- sample(index, trunc(length_data/5))

data_train <- X[-testindex,]
label_train <- Y[-testindex]
data_test <- X[testindex,]
label_test <- Y[testindex]

dtrain <- xgb.DMatrix(data = data_train, label = label_train)
bst <- xgboost(data = dtrain, max.depth = 2, eta = 1, nthread = 2, nround = 50, objective = "multi:softmax", num_class = 21, verbose = 0)
pred <- predict(bst, data_test)
print(length(pred))
print(head(pred))
err <- mean(pred != label_test)
print(paste("test-error=", err))
1 - err

#select the best parameter
#select eta
set.seed(1)
error_rate <- vector()
for (i in 1:10){
  cv.res <- xgb.cv(data = data_train, label = label_train, max.depth = 2, eta = i, min_child_weight = 1, nround = 29, subsample = 1,colsample_bytree = 1, objective = "multi:softmax", num_class = 21, nfold = 5)
  error_rate[i] <- mean(cv.res$evaluation_log$test_merror_mean)
}
error_rate
plot(error_rate, xlab = "eta", ylab = "error rate", type = "l", main = "select the best eta")
Eta <- as.numeric(which.min(error_rate))
Eta
#1
error_rate[which.min(error_rate)]
1 - error_rate[which.min(error_rate)]
#12.86%

#select the max_depth
set.seed(2)
error_rate <- vector()
for (i in 2:10){
  cv.res <- xgb.cv(data = data_train, label = label_train, max.depth = i, eta = Eta, min_child_weight = 1, nround = 29, subsample = 1, colsample_bytree = 1, objective = "multi:softmax", num_class = 21, nfold = 5)
  error_rate[i] <- mean(cv.res$evaluation_log$test_merror_mean)
}
error_rate
plot(error_rate, xlab = "max.depth", ylab = "error rate", type = "l", main = "select the best max_depth")
Max.depth <- as.numeric(which.min(error_rate))
Max.depth
#3
error_rate[which.min(error_rate)]
1-error_rate[which.min(error_rate)]
#13.26%

#select the Min_child_weight
set.seed(3)
error_rate <- vector()
for (i in 1:20){
  cv.res <- xgb.cv(data = data_train, label = label_train, max.depth = Max.depth, eta = Eta, min_child_weight = i, nround = 29,subsample = 1, colsample_bytree = 1, objective = "multi:softmax", num_class = 21, nfold = 5)
  error_rate[i] <- mean(cv.res$evaluation_log$test_merror_mean)
}
error_rate
plot(error_rate, xlab = "min_child_weight", ylab = "error rate", type = "l", main = "select the best min_child_weight")
Min_child_weight <- as.numeric(which.min(error_rate))
Min_child_weight
#10
error_rate[which.min(error_rate)]
1-error_rate[which.min(error_rate)]
#13.70%

#select the Min_child_weight
set.seed(5)
error_rate <- vector()
for (i in 1:50){
  cv.res <- xgb.cv(data = data_train, label = label_train, max.depth = Max.depth, eta = Eta, min_child_weight = Min_child_weight, nround = i,subsample = 1, colsample_bytree = 1, objective = "multi:softmax", num_class = 21, nfold = 5)
  error_rate[i] <- mean(cv.res$evaluation_log$test_merror_mean)
}
error_rate
plot(error_rate, xlab = "nround", ylab = "error rate", type = "l", main = "select the best nround")
Nround <- as.numeric(which.min(error_rate))
Nround
#16
error_rate[which.min(error_rate)]
1-error_rate[which.min(error_rate)]
#13.60%

#The selected parmeters are:
Eta = 1
Max.depth = 3
Min_child_weight = 10
Nround = 16
dtrain <- xgb.DMatrix(data = data_train, label = label_train)
bst <- xgboost(data = dtrain, max.depth = Max.depth, eta = Eta, min_child_weight = Min_child_weight, nround = Nround, subsample = 1, colsample_bytree = 1, objective = "multi:softmax", num_class = 21)
pred <- predict(bst, data_test)
print(length(pred))
print(head(pred))
err <- mean(pred != label_test)
print(paste("test-error=", err))
1 - err

#for predicting ranking
setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4")
load("outcome_label.RData")
outcome_label <- as.matrix(outcome_label)
load("lyr.RData")
dim(lyr)
lyr <- lyr[,-c(1,2,3,6:30)]
dim(lyr)
dim(outcome_label)
words_ranking <- cbind(outcome_label, lyr)
word_names <- colnames(lyr)
cluster <- list()
ranking <- array(0, c(20,4973), dimnames = list(NULL, word_names))
for (i in 1:20){
  cluster[[i]] <- words_ranking[words_ranking[,1] == i,]
  ranking[i, ] <- colMeans(cluster[[i]][,-1])
}
ranking <- round(ranking)
dim(ranking)
ranking <- ranking[-20, ]
dim(ranking)
save(ranking, file = "ranking.RData")
