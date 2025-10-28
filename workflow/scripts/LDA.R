args <- commandArgs(trailingOnly=TRUE)
#Load required libraries
library(MASS)
library(dplyr)
#Reads smartpca output
file=args[1]
data=read.table(file, sep = "")
new_column_names=c("Sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Group")
colnames(data) <- new_column_names

#Reads wild/domestic status for reference panel
status=args[3]
status_data <- read.table(status, header = TRUE, sep = "\t")

#Adds domestic or wild status labels to each sample
data_status <- data %>% left_join(status_data, by = "Sample") %>% mutate(Status = if_else(is.na(Status), "Unknown", Status))

#Separates reference panel and unknown individuals
reference=data_status %>% filter(!grepl('Unknown', Status))
unknown=data_status %>% filter(grepl('Unknown', Status))

#Performs linear discriminant analysis on first 10 principal components based on wild/domestic distinction
lda_model<-lda(Status ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data=reference)
lda_predict <- predict(lda_model, unknown)
lda_posterior<-round(lda_predict$posterior, 4)
#Output results
new_row_names <- unknown$Sample
rownames(lda_posterior) <- new_row_names
output_file=args[2]
write.table(lda_posterior, output_file, col.names=TRUE, row.names=TRUE)
