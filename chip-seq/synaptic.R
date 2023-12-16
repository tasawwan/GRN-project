
for(i in list.files(path = "idr_intersect/synaptic_genes", pattern = "\\.tsv$")) {
    print(i)
    raw_data <- read.table(paste0("idr_intersect/synaptic_genes/", i), sep = "\t", header = F)
    selected_columns <- raw_data[, c(13, 14, 15)]
    unique_rows <- unique(selected_columns)
    
    basename <- unlist(strsplit(i, '.tsv'))
    write.table(unique_rows, file = paste0("idr_intersect/", basename, ".narrowPeak"), sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
}