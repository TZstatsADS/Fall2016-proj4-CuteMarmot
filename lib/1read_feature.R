library(Matrix)
rm(list = ls())
#Read words' data.
setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4/data")
files <- dir(".", recursive = TRUE, full.names = TRUE)

#source("http://bioconductor.org/biocLite.R")
#biocLite("rhdf5")
library(rhdf5)
h5ls("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4/data/A/A/A/TRAAABD128F429CF47.h5")
#######
termana <- h5read("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4/data/A/A/A/TRAAABD128F429CF47.h5", "/analysis")
ptm <- proc.time()
#length1 <- length(termana$bars_confidence)
#length2 <- length(termana$bars_start)
#length3 <- length(termana$beats_confidence)
#length4 <- length(termana$beats_start)
#length5 <- length(termana$sections_confidence)
#length6 <- length(termana$sections_start)
#length7 <- length(termana$segments_confidence)
length8 <- length(termana$segments_loudness_max)
length9 <- length(termana$segments_loudness_max_time)
#length10 <- length(termana$segments_loudness_start)
length11 <- length(termana$segments_pitches)
#length12 <- length(termana$segments_start)
length13 <- length(termana$segments_timbre)
#length14 <- length(termana$tatums_confidence)
#length15 <- length(termana$tatums_start)
segments_loudness_max <- termana$segments_loudness_max
segments_loudness_max_time <- termana$segments_loudness_max_time
segments_segments_pitches <- termana$segments_pitches
segments_segments_timbre <- termana$segments_timbre
song1_Data <- rbind(segments_loudness_max, segments_loudness_max_time, segments_segments_pitches, segments_segments_timbre)

#######
#song_Data <- c()
#song_Data <- array(0, dim = c(2350, 26, 1000))

#dim_loudness_max
dim_loudness_max <- vector()
#loudness_max <- array(0, dim = c(2350))
i <- 1
for (file in files){
  dfanal <- h5read(file, "/analysis")
  segments_loudness_max <- dfanal$segments_loudness_max
  #segments_loudness_max_time <- dfanal$segments_loudness_max_time
  #segments_segments_pitches <- dfanal$segments_pitches
  #segments_segments_timbre <- dfanal$segments_timbre
  #song_Data_raw <- rbind(segments_loudness_max, segments_loudness_max_time, segments_segments_pitches, segments_segments_timbre)
  #song_Data[i,,] <- song_Data_raw
  Dim_loudness_max <- length(segments_loudness_max)
  dim_loudness_max[i] <- Dim_loudness_max 
  #loudness_max[i,] <- dfanal$segments_loudness_max
  i <- i + 1
}
dim_loudness_max[which.max(dim_loudness_max)]
#3292
dim_loudness_max[which.min(dim_loudness_max)]
#4
#In order to unite the data set, cut and repeat them to 2000
dfanal <- h5read(file[1], "/analysis")
segments_loudness_max <- dfanal$segments_loudness_max
difference <- 2000-length(segments_loudness_max)
segments_loudness_max <- rep(segments_loudness_max, length.out = 2000)
segments_loudness_max <- array(0, c(2350, 2000))
i <- 1
for (file in files){
  dfanal <- h5read(file, "/analysis")
  segments_loudness_max_raw <- dfanal$segments_loudness_max
  segments_loudness_max_raw <- rep(segments_loudness_max_raw, length.out = 2000)
  segments_loudness_max[i,] <- segments_loudness_max_raw
  i <- i + 1
}


#read segments_loudness_max_time
dim_loudness_max_time <- vector()
i <- 1
for (file in files){
  dfanal <- h5read(file, "/analysis")
  segments_loudness_max_time <- dfanal$segments_loudness_max_time
  Dim_loudness_max_time <- length(segments_loudness_max_time)
  dim_loudness_max_time[i] <- Dim_loudness_max_time 
  i <- i + 1
}
dim_loudness_max_time[which.max(dim_loudness_max_time)]
#3292
dim_loudness_max_time[which.min(dim_loudness_max_time)]
#4
#unite them into 2000
segments_loudness_max_time <- array(0, c(2350, 2000))
i <- 1
for (file in files){
  dfanal <- h5read(file, "/analysis")
  segments_loudness_max_time_raw <- dfanal$segments_loudness_max_time
  segments_loudness_max_time_raw <- rep(segments_loudness_max_time_raw, length.out = 2000)
  segments_loudness_max_time[i,] <- segments_loudness_max_time_raw
  i <- i + 1
}
proc.time() - ptm

#segments_piches
dfanal <- h5read(file[1], "/analysis")
segments_piches_raw_input <- dfanal$segments_pitches
segments_piches_raw <- array(0, c(12,2000))
for (j in 1:12){
  segments_piches_raw[j,] <- rep(segments_piches_raw_input[j,], length.out = 2000)
}
segments_pitches[1,,] <- segments_piches_raw

segments_pitches <- array(0, c(2350, 12, 2000))
i <- 1
for (file in files){
  dfanal <- h5read(file, "/analysis")
  segments_piches_raw_input <- dfanal$segments_pitches
  segments_piches_raw <- array(0, c(12,2000))
  for (j in 1:12){
    segments_piches_raw[j,] <- rep(segments_piches_raw_input[j,], length.out = 2000)
  }
  segments_pitches[i,,] <- segments_piches_raw
  i <- i + 1
}

#segments_timbre
segments_timbre <- array(0, c(2350, 12, 2000))
dfanal <- h5read(file[1], "/analysis")
segments_timbre_raw_input <- dfanal$segments_timbre
segments_timbre_raw <- array(0, c(12,2000))
for (j in 1:12){
  segments_timbre_raw[j,] <- rep(segments_timbre_raw_input[j,], length.out = 2000)
}
segments_timbre[1,,] <- segments_timbre_raw

segments_timbre <- array(0, c(2350, 12, 2000))
i <- 1
for (file in files){
  dfanal <- h5read(file, "/analysis")
  segments_timbre_raw_input <- dfanal$segments_timbre
  segments_timbre_raw <- array(0, c(12,2000))
  for (j in 1:12){
    segments_timbre_raw[j,] <- rep(segments_timbre_raw_input[j,], length.out = 2000)
  }
  segments_timbre[i,,] <- segments_timbre_raw
  i <- i + 1
}
setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4")

save(segments_loudness_max, file = "loudness_max.RData")
save(segments_loudness_max_time, file = "loudness_max_time.RData")
save(segments_pitches, file = "pitches.RData")
save(segments_timbre, file = "timbre.RData")

#######
#rm(list = ls())
#setwd("/Users/kaishengwang/Desktop/Applied Data Science Project 4")
#load("data/songs.RData")
#load("lyr.RData")

#install.packages("LDAvisData")
#library(NLP)
#library(tm)
#library(lda)
#library(LDAvis)