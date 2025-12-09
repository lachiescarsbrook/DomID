args <- commandArgs(trailingOnly=TRUE)
#Load required libraries
library(MASS)
library(dplyr)
#Reads PCA (.evec) file
evec_file=args[1]
data=read.table(evec_file, sep = "")
new_column_names=c("Sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Group")
colnames(data) <- new_column_names

#Reads eigenvalues (.eval) file, and weights PCs
eval_file=args[2]
eigs=scan(eval_file) 

for (i in 1:10) {
  pc_name <- paste0("PC", i)
  data[[pc_name]] <- data[[pc_name]] * sqrt(eigs[i])
}

#Reads wild/domestic status for reference panel
status=args[3]
status_data <- read.table(status, header = TRUE, sep = "\t")

#Reads sample statistics
stats=args[4]
stats_data <- read.table(stats, header = TRUE, sep = "\t")

#Adds domestic or wild status labels and statistics to each sample
status_data_merged <- data %>% left_join(status_data, by = "Sample") %>% mutate(Status = if_else(is.na(Status), "Unknown", Status))
status_stats_data_merged <- status_data_merged %>% left_join(stats_data, by = "Sample") 

#Separates reference panel and unknown individuals, and filters those below thresholds
taxonSNP=as.numeric(args[5])
reference=status_stats_data_merged %>% filter(!grepl('Unknown', Status))
unknown=status_stats_data_merged %>% filter(grepl("Unknown", Status) & SNPs > taxonSNP)

#Performs linear discriminant analysis on first 10 principal components, with groups representing dog/wolf distinction
lda_model<-lda(Status ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=reference)
lda_predict <- predict(lda_model, unknown)
lda_posterior<-round(lda_predict$posterior, 4)

#Output results
rownames(lda_posterior) <- unknown$Sample
lda_output <- data.frame(Sample = unknown$Sample, lda_posterior)
output_file=args[6]
write.table(lda_output, output_file, quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
