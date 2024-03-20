#####
# title: "ChIPseeker"
# author: "Tas Rahman
# date: "02/20/2024"
# last modified: "03/19/2024"
#####

setwd("~/scratch/chipseq")

# Install packages
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("ChIPseeker")
BiocManager::install("clusterProfiler")
BiocManager::install("TxDb.Dmelanogaster.UCSC.dm3.ensGene")
install.packages("UpSetR")


## Load packages
library(ChIPseeker)
library(TxDb.Dmelanogaster.UCSC.dm3.ensGene)
txdb <- TxDb.Dmelanogaster.UCSC.dm3.ensGene
library(clusterProfiler)
library(ggplot2)
library(UpSetR)

## Load Data
# Define the path to the idr_intersect folder
folder_path <- "idr_intersect"

# Define the file names
file_names <- c("neurons_10to12_only.narrowPeak", 
                "neurons_10to12_only_synaptic_3k.narrowPeak", 
                "neurons_10to12_only_synaptic_10k.narrowPeak", 
                "neurons_10to12_only_synaptic_50k.narrowPeak")

# If running from command line and want to change the files being used uncomment this
# args <- commandArgs(trailingOnly = TRUE)
# folder_path = args[1]
# file_names = args[-1]

## Read the data
# Read peak files into a list of GRanges for downstream analysis
peaks <- lapply(file_names, function(file_name) {
  file_path <- file.path(folder_path, file_name)
  readPeakFile(file_path)
})
names(peaks) <- file_names

## Inspect the files in r studio 
# Read peak files into a list of dataframes for inspection
dfList <- lapply(file_names, function(file_name) {
  file_path <- file.path(folder_path, file_name)
  peak <- readPeakFile(file_path)
  as.data.frame(peak)
})
names(dfList) <- file_names

# Assign each data frame in dfList to a separate variable
for(i in seq_along(dfList)) {
  assign(paste0("input_", names(dfList)[i]), dfList[[i]])
}

## Peak Annotation
# ChIP peak annotation comparision
peakAnnoList <- lapply(peaks, function(gr) {
  annotatePeak(gr, TxDb=txdb, tssRegion=c(-3000, 3000), verbose=FALSE)
})

# Summary
peakAnnoList
#Sink is used to capture output into a file
sink("ChiPSeeker/annotation_summary.txt")
peakAnnoList
sink()


## Visualize the annotations
# Plot annotation barplot
plotAnnoBar(peakAnnoList, title="Peak Annotation")

# Save AnnoBar plot
ggsave(filename = "ChiPSeeker/Peak_Annotation.png", scale = 2)


#Upset plot
for(i in seq_along(dfList)){
  df <- dfList[i]
  upsetplot(as.data.frame(df))
}

## Save and subset the annotations
for(i in seq_along(peakAnnoList)) {
  
  print(names(peakAnnoList)[i])

  ## Save the annotated files
  # Convert the csAnno object to a data frame
  df <- as.data.frame(peakAnnoList[[i]])
  
  # Create a variable with the name of the csAnno object and assign the data frame to it
  assign(paste0("annotated_", names(peakAnnoList)[i]), df)

  # Save the files to a folder
  write.table(df, file = paste0("ChiPSeeker/annotations_all/annotated_", names(peakAnnoList)[i]), sep="\t", quote=FALSE, row.names=FALSE)

  ## Subset the annotated files

  # Edit the annotation column to group introns and exons
  # Loop over the unique annotations in the data frame
  for (j in unique(df$annotation)) {
    # Define the subset type based on the annotation
    if (grepl("intron 1 of", j)) {
      subset_type <- "First-Intron"
    } else if (grepl("intron", j) && !grepl("intron 1 of", j)) {
      subset_type <- "Other-Intron"
    } else if (grepl("exon 1 of", j)) {
      subset_type <- "First-Exon"
    } else if (grepl("exon", j) && !grepl("exon 1 of", j)) {
      subset_type <- "Other-Exon"
    } else {
      subset_type <- j
    }
    
    # Replace the annotation in the data frame
    df$annotation[df$annotation == j] <- subset_type
  }
  
  for (j in unique(df$annotation)) {
    subset_df <- df[df$annotation == j,]
    # Replace spaces in j with dashes
    subset_type <- gsub(" ", "-", j)
    subset_name <- paste0(subset_type,"_", names(peakAnnoList)[i])
    print(subset_name)

    subset_name <- paste0(subset_type,"_", names(peakAnnoList)[i])
    print(subset_name)

    #save subset dataframe
    assign(subset_name, subset_df)

    # Save to table
    write.table(subset_df, file = paste0("ChiPSeeker/annotations_subset/", subset_name), sep="\t", quote=FALSE, row.names=FALSE)
  }
}