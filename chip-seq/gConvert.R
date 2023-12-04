
#Read in the metadata and subset for only the optimal IDR peak files that use the dm6
report <- read.table(chipseq_data/"metadata.tsv", sep = "\t", header = T)
optimal <- subset(report, Output.type =="optimal IDR thresholded peaks" & File.assembly == "dm6")

#Create a metadata file, fill in with the correct column names
metadata <- data.frame(matrix(ncol = 10, nrow = nrow(optimal)))
colnames(metadata) <- c('experimentTarget','fileAccession',
                        'ERR3975815_ERR3975819-ERR3975833_ERR3975864', #Number of peaks in the intersect with modencode
                        'ERR3975825_ERR3975848-ERR3975862_ERR3975871', 
                        'ERR3975830_ERR3975879-ERR3975820_ERR3975827', 
                        'ERR3975860_ERR3975869-ERR3975846_ERR3975875', 
                        'percent_overlap_ERR3975815_ERR3975819-ERR3975833_ERR3975864', #Number of peaks in intersect over original
                        'percent_overlap_ERR3975825_ERR3975848-ERR3975862_ERR3975871',
                        'percent_overlap_ERR3975830_ERR3975879-ERR3975820_ERR3975827',
                        'percent_overlap_ERR3975860_ERR3975869-ERR3975846_ERR3975875')

#Create a counter
count <- 1
num <- 1

#Add the file accession names and the experiment targets
for(j in optimal$File.accession){
  print(j)
  file <- list.files(pattern = chipseq_data/bed/${j}.bed.gz) #Not sure what we're doing with this tbh
  metadata$experimentTarget[count] <- unlist(strsplit(optimal$Experiment.target[count], '-dmelanogaster'))
  metadata$fileAccession[count] <- optimal$File.accession[count]
  count <- count + 1
  num <- 1
}

## NOT SURE WHSATS HAPPENING HERE

#loop commands through each file
for(i in files){
df <- read.table(i, sep = "\t") # read one file in files into dataframe
head(df)
dim(df)
V4 <- df[4] # extract column 4 with refSeq names
dim(V4)
# Remove duplicates based on V4 columns
uniqueV4 <- V4[!duplicated(V4$V4), ]
dim(uniqueV4)
# convert refSeq names to ENSG and gene names
dfConvert <- gconvert(query = unlist(uniqueV4), organism = "dmelanogaster",
         target="ENSG", mthreshold = Inf, filter_na = TRUE)
dim(dfConvert)
unique <- dfConvert[!duplicated(dfConvert$target), ]
dim(unique)
write.csv(unique, paste0("./convertedGenes/", i,".csv"), row.names=F)
}

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

write.csv(metadata, file = "summary.csv")