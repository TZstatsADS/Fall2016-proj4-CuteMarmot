rm(list = ls())
setwd("/Users/kaishengwang/Downloads/TestSongFile100/submit/")
#loudness_max
set.seed(1)
load("loudness_max.RData")
dim(segments_loudness_max)
set.seed(20)
Loudness_max_Cluster <- kmeans(segments_loudness_max[,1:2000], 10, nstart = 10)
Loudness_max_Cluster$cluster
Loudness_max_C <- cbind(Loudness_max_Cluster$cluster,segments_loudness_max)
View(Loudness_max_C)
hist(Loudness_max_C[,1])

#loudness_max_time
set.seed(2)
load("loudness_max_time.RData")
dim(segments_loudness_max_time)
set.seed(20)
Loudness_max_time_Cluster <- kmeans(segments_loudness_max_time[,1:2000], 10, nstart = 10)
Loudness_max_time_Cluster$cluster
Loudness_max_time_C <- cbind(Loudness_max_time_Cluster$cluster,segments_loudness_max_time)
View(Loudness_max_time_C)
hist(Loudness_max_time_C[,1])

#pitches
set.seed(3)
load("pitches.RData") 
dim(segments_pitches)
set.seed(20)
pitches_matrix <- array(0, c(100,2000))
pitches_mean <- array(0,c(2000))
for (i in 1:100){
  for (j in 1:2000){
    pitches_mean[j] <- mean(segments_pitches[i,,j])
  }
  pitches_matrix[i, ] <- pitches_mean[1:2000]
}
Pitches_Cluster <- kmeans(pitches_matrix[,1:2000], 10, nstart = 10)
Pitches_Cluster$cluster
Pitches_C <- cbind(Pitches_Cluster$cluster,pitches_matrix)
View(Pitches_C)
hist(Pitches_C[,1])

#Timbre
load("timbre.RData") 
dim(segments_timbre)
set.seed(20)
timbre_matrix <- array(0, c(100,2000))
timbre_mean <- array(0,c(2000))
for (i in 1:100){
  timbre_mean <- array(0,c(2000))
  for (j in 1:2000){
    timbre_mean[j] <- mean(segments_timbre[i,,j])
  }
  timbre_matrix[i, ] <- timbre_mean[1:2000]
}
Timbre_Cluster <- kmeans(timbre_matrix[,1:2000], 10, nstart = 10)
Timbre_Cluster$cluster
Timbre_C <- cbind(Timbre_Cluster$cluster,timbre_matrix)
View(Timbre_C)
hist(Timbre_C[,1])

Cluster_Loudness_max <- as.factor(Loudness_max_Cluster$cluster)
CLuster_Loudness_max <- relevel(Cluster_Loudness_max, ref = "1")
contrasts(Cluster_Loudness_max)

Cluster_Loudness_max_time <- as.factor(Loudness_max_time_Cluster$cluster)
Cluster_Loudness_max_time <- relevel(Cluster_Loudness_max_time, ref = "1")
contrasts(Cluster_Loudness_max_time)

Cluster_Pitches <- as.factor(Pitches_Cluster$cluster)
Cluster_Pitches <- relevel(Cluster_Pitches, ref = "1")
contrasts(Cluster_Pitches)

Cluster_Timbre <- as.factor(Timbre_Cluster$cluster)
Cluster_Timbre <- relevel(Cluster_Timbre, ref = "1")
contrasts(Cluster_Timbre)

Input_Data <- cbind(Cluster_Loudness_max, Cluster_Loudness_max_time, Cluster_Pitches, Cluster_Timbre)
dim(Input_Data)
save(Input_Data, file = "Input_Data.RData")
