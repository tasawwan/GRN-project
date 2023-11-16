

report <- read.table("metadata.tsv", sep = "\t", header = T)
optimal <- subset(report, Output.type =="optimal IDR thresholded peaks" & File.assembly == "dm6")

# write.csv(optimal, "summary/optimal.csv")

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

for(j in optimal$File.accession){
  print(j)
  file <- list.files(pattern = j)
  metadata$experimentTarget[count] <- unlist(strsplit(optimal$Experiment.target[count], '-dmelanogaster'))
  metadata$fileAccession[count] <- optimal$File.accession[count]
  
  # for(n in file){
  #   print(num)
  #   fs <- file.info(n)
  #   if (fs$size == 0) {
  #     next
  #   }
  #   df <- read.table(n, sep = "\t") # read one file in files into dataframe
  #   bits <- unlist(strsplit(n, '_'))
  #   geneSet <- do.call(rbind, strsplit(bits[3], '='))
  #   V4 <- df[4] # extract column 4 with refSeq names
  #   dim(V4)
  #   # Remove duplicates based on V4 columns
  #   uniqueV4 <- unique(V4)
  #   dim(uniqueV4)
  #   # convert refSeq names to ENSG and gene names
  #   dfConvert <- gconvert(query = unlist(uniqueV4), organism = "dmelanogaster",
  #                         target="ENSG", mthreshold = Inf, filter_na = TRUE)
  #   dim(dfConvert)
  #   unique <- dfConvert[!duplicated(dfConvert$target), ]
  #   geneCount <- length(unique$target)
  #   if (geneCount == 0) {
  #     next
  #   }
  #   metadata[count, geneSet] <- geneCount
  #   num <- num + 1
  # }
  count <- count + 1
  num <- 1
}

metadata[,4] <- metadata[,3]/463
metadata[,6] <- metadata[,5]/455
metadata[,8] <- metadata[,7]/460
metadata[,10] <- metadata[,9]/461
metadata[,12] <- metadata[,11]/460
metadata[,14] <- metadata[,13]/10037
metadata[,16] <- metadata[,15]/3649

write.csv(metadata, file = "window1k_allENCODE_dm6_otp_20230202.csv")


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

