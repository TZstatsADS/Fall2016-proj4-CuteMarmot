#rm(list = ls())
setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4")
load("input_data.RData")
load("ranking.RData")
names_word <- colnames(ranking)
index <- 1:2350
index_sample <- sample(index, 100)
input_Data <- Input_Data[index_sample, ]
data_test <- input_Data
#dtrain <- xgb.DMatrix(data = data_train, label = label_train)
bst <- xgboost(data = dtrain, max.depth = Max.depth, eta = Eta, min_child_weight = Min_child_weight, nround = Nround, subsample = 1, colsample_bytree = 1, objective = "multi:softmax", num_class = 21)
for (i in 1:4){
  data_test[,i] <- as.numeric(data_test[,i])
}
pred <- predict(bst, data_test)
print(length(pred))
dim(ranking)
length(pred)


ranking_outcome <- array(0, c(100, 4973), dimnames = list(NULL, names_word))
for (j in 1:19){
  index <- 1:100
  index <- index[pred == j]
  if (length(index) == 1) {
    ranking_outcome[index,] <- ranking[j,]
  } else if (length(index) > 1) {
    for (i in 1:length(index)){
      ranking_outcome[index,][i,] <- ranking[j,]
    }
  }
}

View(ranking_outcome)
dim(ranking_outcome)
index <- 1:4973
index <- index[!ranking_outcome[5,] == 0]
View(ranking_outcome[,101])

setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4")
save(ranking_outcome, file = "ranking_outcome.RData")
