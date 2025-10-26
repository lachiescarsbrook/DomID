args <- commandArgs(trailingOnly=TRUE)
#Load required libraries
library(ggplot2)
library(ggrepel)
library(dplyr)

#Reads in data
sex=args[1]
sex_data <-  read.table(sex, header = TRUE, sep = "\t")

##SEX ASSIGN
#Assign confident males
sex_data$SexID[sex_data$RY >= 0.04322211 & sex_data$RY <= 0.06946789 & sex_data$RX >= 0.25 & sex_data$RX <= 0.75] <- "M"
#Assign possible males
sex_data$SexID[is.na(sex_data$SexID) & sex_data$RY > 0.02129674 & sex_data$RX < 0.75] <- "?M"
#Assign confident females
sex_data$SexID[is.na(sex_data$RY) >= -0.0001143262 & sex_data$RY <= 0.0006286262 & sex_data$RX >= 0.75 & sex_data$RX <= 1.25] <- "F"
#Assign possible females
sex_data$SexID[is.na(sex_data$SexID) & sex_data$RY < 0.02129674 & sex_data$RX > 0.75] <- "?F"
#Assign unknown to rest
sex_data$SexID[is.na(sex_data$SexID)] <- "U"

#Assign fill colours
custom_fill <- c("U" = "darkgrey", "F" = "pink", "?F" = "#ffebf0", "M" = "#0453b1","?M" = "#cae0fc")
sex_data$fill_var <- sex_data$SexID

#Modify labels to include Sample ID + read count
sex_data <- sex_data %>% mutate(label = paste0(Sample, " (", Mapped_Reads_Q30_NoDup, " reads)"))

#Plots RX/RY with unknown samples labelled
pdf(args[2])
ggplot(sex_data, aes(x = RX, y = RY, label = Sample, fill = fill_var)) + geom_hline(yintercept = 0.02129674, linetype = "dashed", colour = "grey", linewidth = 0.5) + annotate("rect", xmin = -Inf, xmax = Inf, ymin = -0.0001143262, ymax = 0.0006286262, fill = "pink", alpha = 0.4) + annotate("rect", xmin = -Inf, xmax = Inf, ymin = 0.04322211, ymax = 0.06946789, fill = "#0453b1", alpha = 0.2) + geom_vline(xintercept = c(0.5), colour = "#0453b1", linewidth = 1) + geom_vline(xintercept = c(1), colour = "pink", linewidth = 1) + geom_errorbarh(aes(xmin = RX_Min, xmax = RX_Max), height = 0.005, colour="grey") + geom_errorbar(aes(ymin = (RY - RY_SE), ymax = (RY + RY_SE)), width = 0.01, colour="grey") + geom_point(size = 4, shape = 21) + theme(axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12), axis.title.x = element_text(size = 13), axis.title.y = element_text(size = 13), panel.background = element_blank(), legend.position = "none", axis.line.x = element_line(color = "black", size = 0.2), axis.line.y = element_line(color = "black", size = 0.2)) + scale_fill_manual(values = custom_fill) + scale_shape_manual(values = c(21, 23, 21, 23)) + geom_text_repel(aes(label = label), na.rm = TRUE, force = 2, box.padding = 1, max.overlaps = NA, size = 2.5, segment.linetype= "dashed", segment.size = 0.1) + labs(x = "Autosome-X Coverage Ratio (RX)", y = "Y-Coverage Ratio (RY)") 
dev.off()

#Filter dataset to keep relevant columns
subset_sex_data <- sex_data[, c("Sample", "Mapped_Reads_Q30_NoDup", "SexID")]
#Write to file
write.table(subset_sex_data, file = args[3], sep = "\t",quote = FALSE,row.names = FALSE)