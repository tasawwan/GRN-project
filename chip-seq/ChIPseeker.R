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


## Load packages
library(ChIPseeker)
library(TxDb.Dmelanogaster.UCSC.dm3.ensGene)
txdb <- TxDb.Dmelanogaster.UCSC.dm3.ensGene
library(clusterProfiler)
library(ggplot2)

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

# Plot annotation barplot
plotAnnoBar(peakAnnoList, title="Peak Annotation")

# Save AnnoBar plot
ggsave(filename = "ChiPSeeker/Peak_Annotation.png", scale = 2)

# Create dataframes for the annotations and write as a narrowpeak
for(i in seq_along(peakAnnoList)) {
  # Convert the csAnno object to a data frame
  df <- as.data.frame(peakAnnoList[[i]])
  
  # Create a variable with the name of the csAnno object and assign the data frame to it
  assign(paste0("annotated_", names(peakAnnoList)[i], df))

  # Save the files to a folder
  write.table(df, file = paste0("ChiPSeeker/annotations_all/annotated_", names(peakAnnoList)[i]), sep="\t", quote=FALSE, row.names=FALSE)

  # Now I want to subset these files by the annotation in the annotation column
  for (j in unique(df$annotation)) {
    subset_df <- df[df$annotation == j,]
    
    #save subset dataframe
    assign(paste0(j,"_", names(peakAnnoList)[i]), subset_df)
    
    # Save to table
    write.table(subset_df, file = paste0("ChiPSeeker/annotations_subset/", j, "_", names(peakAnnoList)[i]), sep="\t", quote=FALSE, row.names=FALSE)
  }
}



# Now we want to subset each of these files, we want distal intergenic and promoters (all shoved together) and everything else together
# Ideally we want every category as its own thing


# We want to see peaks of accessible regions are at promoters, at introns, exons, and intergenic regions
# We are going to run this on our 4 10 to 12 only files in the idr_intersection folder