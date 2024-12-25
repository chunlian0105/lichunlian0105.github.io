library(stringr)
setwd("/data/lcl/cohort_result/6-Ten_pairs/bowtie2_results")
list.files()
## read multiple files in one time and name these files
temp <- list.files(pattern = "*.txt")
myfiles = lapply(temp, function(x)read.table(x,sep = "\t"))
length(myfiles)
names(myfiles) <- temp
head(myfiles$`ERR1449717_idxstats.txt`)

## calculate tpm/GCPM (Gene coverage per kilobase million) values
tpm <- function(counts, lengths) {
  rate <- counts / lengths
  rate / sum(rate) * 1e6
}
myfiles_clean <- list()
for (i in c(1:length(myfiles))){
  myfiles[[i]] <- as.data.frame(myfiles[[i]])
  t <- nrow(myfiles[[i]])
  myfiles_clean[[i]] <-myfiles[[i]][-t,] 
  myfiles_clean[[i]]$tpm <- tpm(myfiles_clean[[i]]$V3,myfiles_clean[[i]]$V2)
  myfiles_clean[[i]] <- myfiles_clean[[i]][,-6]
  print(sum(myfiles_clean[[i]]$tpm))
  
}
names(myfiles_clean) <- names(myfiles) 
length(myfiles_clean)
length(myfiles)
tail(myfiles_clean[[1]])
## rename each contigs in the different files
a <- as.vector(gsub("_idxstats.txt", "", names(myfiles_clean)))
for (i in c(1:length(myfiles_clean))){
  myfiles_clean[[i]]$Gene_code <- paste(a[i],myfiles_clean[[i]]$V1, sep="-")
}
tail(myfiles_clean[[20]])
save(myfiles_clean, file = "myfiles_clean_Ten_pairs.RData")











