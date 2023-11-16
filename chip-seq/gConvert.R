

report <- read.table("metadata.tsv", sep = "\t", header = T)
optimal <- subset(report, Output.type =="optimal IDR thresholded peaks" & File.assembly == "dm6")


metadata <- data.frame(matrix(ncol = 10, nrow = nrow(optimal)))
colnames(metadata) <- c('experimentTarget','fileAccession',
                        'ERR3975815_ERR3975819-ERR3975833_ERR3975864',
                        'ERR3975825_ERR3975848-ERR3975862_ERR3975871', 
                        'ERR3975830_ERR3975879-ERR3975820_ERR3975827', 
                        'ERR3975860_ERR3975869-ERR3975846_ERR3975875', 
                        'percent_overlap_ERR3975815_ERR3975819-ERR3975833_ERR3975864',
                        'percent_overlap_ERR3975825_ERR3975848-ERR3975862_ERR3975871',
                        'percent_overlap_ERR3975830_ERR3975879-ERR3975820_ERR3975827',
                        'percent_overlap_ERR3975860_ERR3975869-ERR3975846_ERR3975875')

count <- 1
num <- 1





#ChatGPT (THIS IS WRONG)
# Loop through each input
for (input_combination in c('ERR3975815_ERR3975819_ERR3975833_ERR3975864',
                             'ERR3975825_ERR3975848-ERR3975862_ERR3975871', 
                             'ERR3975830_ERR3975879-ERR3975820_ERR3975827', 
                             'ERR3975860_ERR3975869-ERR3975846_ERR3975875')) {
  
  # Extract accession numbers from the input combination
  accessions <- strsplit(input_combination, "_")[[1]]
  
  # Create column names for the current input
  input_col <- paste('percent_overlap', input_combination, sep = "_")
  
  # Add input column to the metadata dataframe
  metadata[, (num + 6)] <- rep(NA, nrow(optimal))
  colnames(metadata)[(num + 6)] <- input_col
  
  # Loop through each accession in the current input
  for (accession in accessions) {
    
    # Read the corresponding BED file
    bed_file <- paste("intersection_directory", "/", input_combination, "_", accession, ".bed", sep = "")
    bed_data <- read.table(bed_file, sep = "\t", header = FALSE)
    
    # Count the number of lines in the BED file
    line_count <- nrow(bed_data)
    
    # Calculate the percentage of overlapping peaks
    percent_overlap <- line_count / total_peaks_in_chipseq_bedfile * 100
    
    # Assign the percentage to the metadata dataframe
    metadata[, (num + 6)] <- percent_overlap
  }
  
  num <- num + 1
}

# Write the metadata dataframe to a CSV file
write.csv(metadata, "output_file.csv", row.names = FALSE)












#Original

for(j in optimal$File.accession){
  print(j)
  file <- list.files(pattern = chipseq_data/bed/${j}.bed.gz)
  metadata$experimentTarget[count] <- unlist(strsplit(optimal$Experiment.target[count], '-dmelanogaster'))
  metadata$fileAccession[count] <- optimal$File.accession[count]
  count <- count + 1
  num <- 1
}


write.csv(metadata, file = "summary.csv")


# loop commands through each file
# for(i in files){
# df <- read.table(i, sep = "\t") # read one file in files into dataframe
# head(df)
# dim(df)
# V4 <- df[4] # extract column 4 with refSeq names
# dim(V4)
# # Remove duplicates based on V4 columns
# uniqueV4 <- V4[!duplicated(V4$V4), ]
# dim(uniqueV4)
# # convert refSeq names to ENSG and gene names
# dfConvert <- gconvert(query = unlist(uniqueV4), organism = "dmelanogaster",
#          target="ENSG", mthreshold = Inf, filter_na = TRUE)
# dim(dfConvert)
# unique <- dfConvert[!duplicated(dfConvert$target), ]
# dim(unique)
# write.csv(unique, paste0("./convertedGenes/", i,".csv"), row.names=F)
# }

metadata <- data.frame()

for(i in files){
  df <- read.table(i, sep = "\t") # read one file in files into dataframe
  V4 <- df[4] # extract column 4 with refSeq names
  dim(V4)
  # Remove duplicates based on V4 columns
  uniqueV4 <- unique(V4)
  dim(uniqueV4)
  # convert refSeq names to ENSG and gene names
  dfConvert <- gconvert(query = unlist(uniqueV4), organism = "dmelanogaster",
                        target="ENSG", mthreshold = Inf, filter_na = TRUE)
  dim(dfConvert)
  unique <- dfConvert[!duplicated(dfConvert$target), ]
  dim(unique)
  write.csv(unique, paste0("./convertedGenes/", i,".csv"), row.names=F)
}

genes <- length(unique$target)
metadata[i,1] <- files[1]
metadata[i,2] <- 

