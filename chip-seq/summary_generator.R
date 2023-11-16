
#Read in the metadata and subset for only the optimal IDR peak files that use the dm6
report <- read.table("chipseq_data/metadata.tsv", sep = "\t", header = T)
optimal <- subset(report, Output.type =="optimal IDR thresholded peaks" & File.assembly == "dm6")

#Create a summary file, fill in with the correct column names
summary <- data.frame(matrix(ncol = 2, nrow = nrow(optimal)))
colnames(summary) <- c('experimentTarget','fileAccession')

#Create a counter
count <- 1

#Add the file accession names and the experiment targets
for(i in optimal$File.accession){
  print(i)  
  summary$experimentTarget[count] <- unlist(strsplit(optimal$Experiment.target[count], '-dmelanogaster'))
  summary$fileAccession[count] <- optimal$File.accession[count]
  count <- count + 1
}

#Get the counts of the intersection files

# Initialize the empty dataframe
intersection <- data.frame(basename = character(), accession = character(), num_lines = integer())

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


# Get the counts of the background files

# Initialize the empty dataframe
idr <- data.frame(basename = character(), num_lines = integer())

for(i in list.files(path = "idr_intersect", pattern = "\\.narrowPeak$")) {
  
  print(i)

  # Read the file
  lines <- readLines(paste0("idr_intersect/", i))

  # Count the lines
  num_lines <- length(lines)

  # Print the number of lines
  print(num_lines)  

  # Basename
  basename <- unlist(strsplit(i, '.narrowPeak'))

  # Add the data to the data frame
  idr <- rbind(idr, data.frame(basename = basename, num_lines = num_lines))
}

  # Update the meta data with the counts from the summary generator
for(i in 1:nrow(summary)){

  print(i)

  # Get the accession
  summary_accession <- summary$fileAccession[i]
  print(summary_accession)

  for(j in 1:nrow(idr)){
    idr_basename <- idr$basename[j]
    print(idr_basename)

    summary[i, idr_basename] <- intersection[intersection$basename == idr_basename & intersection$accession == summary_accession,]$num_lines
    
    overlap_idr_basename <- paste0("percent_overlap_", idr_basename)
    print(overlap_idr_basename)
    summary[i, overlap_idr_basename] <- summary[i, idr_basename] / idr[idr$basename == idr_basename,]$num_lines
  }
}

write.csv(summary, file = "summary_files/summary.csv")
write.csv(idr, file = "summary_files/idr.csv")
write.csv(intersection, file = "summary_files/intersection.csv")



