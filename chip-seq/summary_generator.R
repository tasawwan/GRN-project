
#Read in the metadata and subset for only the optimal IDR peak files that use the dm6
report <- read.table("chipseq_data/metadata.tsv", sep = "\t", header = T)
optimal <- subset(report, Output.type =="optimal IDR thresholded peaks" & File.assembly == "dm6")

#Create a metadata file, fill in with the correct column names
metadata <- data.frame(matrix(ncol = 10, nrow = nrow(optimal)))
colnames(metadata) <- c('experimentTarget','fileAccession',
                        'neurons_10to12', #Number of peaks in the intersect with modencode
                        'non', 
                        'neurons_8to10', 
                        'meso', 
                        'percent_overlap_neurons_10to12', #Number of peaks in intersect over original
                        'percent_overlap_non',
                        'percent_overlap_neurons_8to10',
                        'percent_overlap_meso')

#Create a counter
count <- 1

#Add the file accession names and the experiment targets
for(i in optimal$File.accession){
  print(i)  
  metadata$experimentTarget[count] <- unlist(strsplit(optimal$Experiment.target[count], '-dmelanogaster'))
  metadata$fileAccession[count] <- optimal$File.accession[count]
  count <- count + 1
}

# Get the counts of the background files
for(i in list.files(path = "idr_intersect", pattern = "\\.narrowPeak$")) {
  
  print(i)

  # Read the file
  lines <- readLines(paste0("idr_intersect/", i))

  # Count the lines
  num_lines <- length(lines)

  # Print the number of lines
  print(num_lines)  

  #Basename
  basename <- unlist(strsplit(i, '.narrowPeak'))

  #Assign to the number of lines
  assign(basename, num_lines)

}

#Get the counts of the intersection files

# Initialize the empty dataframe
intersection <- data.frame(basename = character(), accession = character(), num_lines = integer())

# Get the counts of the background files
for(i in list.files(path = "intersection", pattern = "\\.bed$")) {
  
  # Print the filename
  print(i)

  # Read the file
  lines <- readLines(paste0("intersection/", i))

  # Count the lines
  num_lines <- length(lines)

  # Split the filename into basename and accession, the weird stuff is the last underscore
  split_name <- unlist(strsplit(i, "_(?=[^_]+$)", perl = TRUE))

  # Get the basename and accession
  basename <- split_name[1]
  accession <- sub(".bed", "", split_name[2])

  print(basename)
  print(accession)

  # Add the data to the data frame
  intersection <- rbind(intersection, data.frame(basename = basename, accession = accession, num_lines = num_lines))
}





##FIXED UP TO HERE

# #loop commands through each file
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

# metadata <- data.frame()

# for(i in files){
#   df <- read.table(i, sep = "\t") # read one file in files into dataframe
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
#   dim(unique)
#   write.csv(unique, paste0("./convertedGenes/", i,".csv"), row.names=F)
# }

# genes <- length(unique$target)
# metadata[i,1] <- files[1]
# metadata[i,2] <- 

write.csv(metadata, file = "summary.csv")