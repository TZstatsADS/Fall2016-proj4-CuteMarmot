#rm(list = ls())x
setwd("/Users/kaishengwang/Downloads/TestSongFile100/submit/")
load("Input_Data_test.RData")
load("ranking.RData")
names_word <- colnames(ranking)
data_test <- Input_Data
#dtrain <- xgb.DMatrix(data = data_train, label = label_train)
bst <- xgboost(data = dtrain, max.depth = Max.depth, eta = Eta, min_child_weight = Min_child_weight, nround = Nround, subsample = 1, colsample_bytree = 1, objective = "multi:softmax", num_class = 21)
for (i in 1:4){
  data_test[,i] <- as.numeric(data_test[,i])
}
pred <- predict(bst, data_test)
print(length(pred))
dim(ranking)
length(pred)


ranking_outcome <- array(0, c(100, 5000), dimnames = list(NULL, names_word))
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
#index <- 1:4973
#index <- index[!ranking_outcome[5,] == 0]
#View(ranking_outcome[,101])
name_songs <- c("song1", "song2", "song3", "song4", "song5", "song6", "song7", "song8", "song9", "song10",
                "song11", "song12", "song13", "song14", "song15", "song16", "song17", "song18", "song19", "song20",
                "song21", "song22", "song23", "song24", "song25", "song26", "song27", "song28", "song29", "song30",
                "song31", "song32", "song33", "song34", "song35", "song36", "song37", "song38", "song39", "song40",
                "song41", "song42", "song43", "song44", "song45", "song46", "song47", "song48", "song49", "song50",
                "song51", "song52", "song53", "song54", "song55", "song56", "song57", "song58", "song59", "song60",
                "song61", "song62", "song63", "song64", "song65", "song66", "song67", "song68", "song69", "song70",
                "song71", "song72", "song73", "song74", "song75", "song76", "song77", "song78", "song79", "song80",
                "song81", "song82", "song83", "song84", "song85", "song86", "song87", "song88", "song89", "song90",
                "song91", "song92", "song93", "song94", "song95", "song96", "song97", "song98", "song99", "song100"
                )
Names_Word <- array(name_songs, c(100,1))
ranking_Final_outcome <- cbind(Names_Word, ranking_outcome)
X <- array(1:100,c(100,1))
dim(X)
dim(ranking_outcome)

dim(ranking_outcome)

#rank_index <- 1:5000
#testsong1_raw <- ranking_outcome[1, ]
#testsong1_raw_rank <- sort(testsong1_raw, decreasing = TRUE)

ranking_Final_outcome <- cbind(X, ranking_Final_outcome)
setwd("/Users/kaishengwang/Downloads/TestSongFile100/submit/")
write.csv(ranking_Final_outcome, file = "ranking_Final_outcome_5000.csv")

ranking_Final_outcome <- read.csv(file = "ranking_Final_outcome_5000.csv")
dim(ranking_Final_outcome)
View(ranking_Final_outcome)
ranking_Final_outcome <- ranking_Final_outcome[,-1]
ranking_Final_outcome <- ranking_Final_outcome[,-1]
ranking_Final_outcome <- ranking_Final_outcome[,-1]
dim(ranking_Final_outcome)
names_col <- colnames(ranking_Final_outcome)
name_raw <- ranking_Final_outcome[,1]
ranking_Final_outcome <- ranking_Final_outcome[,-1]
ranking_Final <- array(NA, c(100,5000))
for (i in 1:100){
  ranking_Final[i, ] <- rank(-as.numeric(ranking_Final_outcome[i, ]))
}
View(ranking_Final)
dim(ranking_Final)
ranking_Final <- data.frame(ranking_Final, row.names = name_raw)
names_col <- names_col[-1]
ranking_Final <- rbind(names_col,ranking_Final)

setwd("/Users/kaishengwang/Downloads/TestSongFile100/submit/")
write.csv(ranking_Final, file = "ranking_Final_5000.csv")
