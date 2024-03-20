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


# Load packages
library(ChIPseeker)
library(TxDb.Dmelanogaster.UCSC.dm3.ensGene)
txdb <- TxDb.Dmelanogaster.UCSC.dm3.ensGene
library(clusterProfiler)
library(ggplot2)

# Define the path to the idr_intersect folder
folder_path <- "idr_intersect"

# Define the file names
file_names <- c("neurons_10to12_only.narrowPeak", 
                "neurons_10to12_only_synaptic_3k.narrowPeak", 
                "neurons_10to12_only_synaptic_10k.narrowPeak", 
                "neurons_10to12_only_synaptic_50k.narrowPeak")

# #If running from command line and want to change the files being used uncomment this
# args <- commandArgs(trailingOnly = TRUE)
# folder_path = args[1]
# file_names = args[-1]

# Read each file
files <- lapply(file_names, function(file_name) {
  file_path <- file.path(folder_path, file_name)
  readPeakFile(file_path)
})

# ChIP peak annotation comparision
peakAnnoList <- lapply(files, function(gr) {
  annotatePeak(gr, TxDb=txdb, tssRegion=c(-3000, 3000), verbose=FALSE)
})

names(peakAnnoList) <- file_names

# Plot annotation barplot
plotAnnoBar(peakAnnoList, title="Peak Annotation")

# Save AnnoBar plot
ggsave(filename = "ChiPSeeker/Peak_Annotation.png", scale = 2)

# I want to get the different narrowpeaks out of each one now
# Loop over the list of csAnno objects
for(i in seq_along(peakAnnoList)) {
  # Convert the csAnno object to a data frame
  df <- as.data.frame(peakAnnoList[[i]])
  
  # Create a variable with the name of the csAnno object and assign the data frame to it
  assign(names(peakAnnoList)[i], df)
}



# Now we want to subset each of these files, we want distal intergenic and promoters (all shoved together) and everything else together
# Ideally we want every category as its own thing


# We want to see peaks of accessible regions are at promoters, at introns, exons, and intergenic regions
# We are going to run this on our 4 10 to 12 only files in the idr_intersection folder