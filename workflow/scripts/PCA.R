args <- commandArgs(trailingOnly=TRUE)
#Load required libraries
library(ggplot2)
library(ggrepel)
library(dplyr)

#Reads summary statistics for unknown samples
snp=args[4]
snp_data <- read.table(snp, header = TRUE, sep = "\t")

#Reads evec output and calculates percentage variance
evec=args[1]
data_evec=read.table(evec, sep = "")
new_column_names=c("Sample","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","Group")
colnames(data_evec) <- new_column_names

#Excludes samples with <50 SNPs
exclude_samples <- snp_data %>% filter(SNPs < 50) %>% pull(Sample)
plot_data_filtered <- data_evec %>% filter(!Sample %in% exclude_samples) %>% left_join(snp_data, by = "Sample")

#Modify labels to include Sample ID + SNP count
plot_data_filtered <- plot_data_filtered %>% mutate(label = ifelse(Group == "Unknown", paste0(Sample, " (", SNPs, " SNPs)"), NA))

#Reads eval output and calculates percentage variance
eval=args[2]
data_eval=read.table(eval, sep = "", header = F, col.names = c("Eigenvalue"))
data_eval$PC=paste0("PC", 1:nrow(data_eval))
eval_sum=sum(data_eval$Eigenvalue)
data_eval$Percentage=round((data_eval$Eigenvalue/eval_sum)*100,3)

#Plots PCA with unknown samples labelled
pdf(args[3])
ggplot(plot_data_filtered, aes(x=PC1, y=PC2, fill = Group, shape = Group, label = Sample)) + geom_point(size=4,alpha = 0.8) + scale_fill_manual(values = c("African_NearEast_India_Dogs" = "black","Americas_Dogs" = "black", "Arctic_Dogs" = "black","Eastern_Eurasian_Wolves" = "grey","East_Asian_Dogs" = "black","European_Dogs" = "black","North_American_Wolves" = "grey","Outgroup" = "white","Tibetan_Wolves" = "grey","Unknown" = "red","Western_Eurasian_Wolves" = "grey")) + scale_shape_manual(values = c("African_NearEast_India_Dogs" = 21,"Americas_Dogs" = 22,"Arctic_Dogs" = 22,"Eastern_Eurasian_Wolves" = 21,"East_Asian_Dogs" = 23,"European_Dogs" = 24,"North_American_Wolves" = 22,"Outgroup" = 21,"Tibetan_Wolves" = 23,"Unknown" = 23,"Western_Eurasian_Wolves" = 24)) + theme(panel.background = element_blank(), axis.line.x = element_line(color="black", size = 0.5), axis.line.y = element_line(color="black", size = 0.5)) + labs(x = paste("PC1 (",data_eval$Percentage[1],"%)"),y = paste("PC2 (",data_eval$Percentage[2],"%)")) + geom_text_repel(aes(label = label), na.rm = TRUE, force = 2, box.padding = 1, max.overlaps = NA, size = 2.5, segment.linetype= "dashed", segment.size = 0.1) + theme(axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12), axis.title.x = element_text(size = 13), axis.title.y = element_text(size = 13), panel.background = element_blank(), axis.line.x = element_line(color="black", size = 0.2), axis.line.y = element_line(color="black", size = 0.2))
dev.off()