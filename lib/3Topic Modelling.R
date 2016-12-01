rm(list = ls())
setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4")
load("lyr.RData")
dim(lyr)
#lyr <- lyr[,-c(1,2,3,6:30)]
lyr <- lyr[,-1]
dim(lyr)
View(lyr)
library(NLP)
library(tm)
library(lda)
library(LDAvis)

get.terms <- function(x){
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index-1), as.integer(rep(1, length(index))))
}
vocab <- names(lyr)
documents <- list()
for (i in 1:2350){
  index <- c(1:5000)
  index <- index[!lyr[i,] == 0]
  name_var <- vocab[index]
  count <- lyr[i,][index]
  documents[[i]] <- as.matrix(rbind(as.integer(index-1), as.integer(count)))
  rm(nae_var)
  rm(count)
}
documents[[1]]

D <- length(documents)
W <- length(vocab)
doc.length <- sapply(documents, function(x) sum(x[2,]))
N <- sum(doc.length)
#term.frequency <- as.integer(term.table)

K <- 20
G <- 100
alpha <- 0.02
eta <- 0.02

library(lda)
set.seed(624)
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, num.iterations = G, alpha = alpha, eta = eta, initial = NULL, burnin = 0, compute.log.likelihood = TRUE)
fit[1]$assignments[1]
as.numeric(names(which.max(table(fit[1]$assignments[4999]))))

outcome_label <- vector()
for (i in 1:2350){
  outcome_label[i] <- as.numeric(names(which.max(table(fit[1]$assignments[i]))))
}

outcome_label <- as.matrix(outcome_label)
dim(outcome_label)
outcome_label <- as.factor(outcome_label)
outcome_label <- relevel(outcome_label, ref = "1")
contrasts(outcome_label)
setwd("/Users/kaishengwang/Desktop/Applied\ Data\ Science\ Project\ 4")
save(outcome_label, file = "outcome_label.RData")
