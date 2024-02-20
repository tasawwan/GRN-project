#####
# title: "ChIPseeker"
# author: "Tas Rahman, modified from script by James Kentro"
# date: "02/20/2024"
# last modified: "02/20/2024"
#####

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

# Define the path to the idr_intersect folder
folder_path <- "idr_intersect"

# Define the file names
file_names <- c("neurons_10to12_only.narrowPeak", 
                "neurons_10to12_only_synaptic_3k.narrowPeak", 
                "neurons_10to12_only_synaptic_10k.narrowPeak", 
                "neurons_10to12_only_synaptic_50k.narrowPeak")

# Read each file
files <- lapply(file_names, function(file_name) {
  file_path <- file.path(folder_path, file_name)
  file_path
})

# ChIP peak annotation comparision
peakAnnoList <- lapply(files, annotatePeak, TxDb=txdb,
                       tssRegion=c(-3000, 3000), verbose=FALSE)
plotAnnoBar(peakAnnoList)


# We want to see peaks of accessible regions are at promoters, at introns, exons, and intergenic regions
# We are going to run this on our 4 10 to 12 only files in the idr_intersection folder


##########JAMES SCRIPT##########

# # ## try http:// if https:// URLs are not supported
# # if (!requireNamespace("BiocManager", quietly=TRUE))
# #   install.packages("BiocManager")
# # ## BiocManager::install("BiocUpgrade") ## you may need this
# # BiocManager::install("ChIPseeker")
# # BiocManager::install('clusterProfiler')
# # BiocManager::install('EnsDb.Hsapiens.v75')
# # BiocManager::install('ReactomePA')
# # BiocManager::install('TxDb.Dmelanogaster.UCSC.dm6.ensGene')
# # BiocManager::install("GenomeInfoDb",force=TRUE)
# # BiocManager::install("org.Dm.eg.db")

# # install.packages('ggupset')
# # install.packages('ggimage')

# ## loading packages
# library(ChIPseeker)
# # library(TxDb.Hsapiens.UCSC.hg19.knownGene)
# library(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
# library(clusterProfiler)

# txdb <- TxDb.Dmelanogaster.UCSC.dm6.ensGene
# txdb

# ### ChIP profiling
# csv <- read.csv('diffbind_Deaf1_vsGFP_differentialSites_female_20230826.csv')
# csv
# csv <- csv[,2:12]
# write.csv(csv, file='diffbind_Deaf1_vsGFP_differentialSites_female_20230911.csv')

# # files <- getSampleFiles()
# files <- list('CGF.narrowPeak.gz','CGM.narrowPeak.gz','DF.narrowPeak.gz','DM.narrowPeak.gz')

# print(files)

# peak <- readPeakFile(files[[3]])
# peak

# seqlevelsStyle(peak) <- "UCSC"

# peak <- subset(peak, seqnames == c('chr2L','chr2R','chr3L','chr3R','chr4','chrX','chrY'))

# peak

# ### ChIP peaks coverage plot

# covplot(peak, weightCol="V5")

# # covplot(peak, weightCol="V5", chrs=c("chr17", "chr18"), xlim=c(4.5e7, 5e7))
# covplot(peak, weightCol="V5", chrs=c('2L','2R','3L','3R','4','X','Y'), xlim=c(1e1, 1e6))

# ### Profile of ChIP peaks binding to TSS regions

# promoter <- getPromoters(TxDb=txdb, upstream=3000, downstream=3000)

# # may need to change chr style
# # newStyle <- mapSeqlevels(seqlevels(peak), "UCSC")
# # peakchr <- renameSeqlevels(peak, newStyle)
# tagMatrix <- getTagMatrix(peak, windows=promoter) # need to remove non-standard chromosomes (and maybe rename to chr2L, etc.)


# # to speed up the compilation of this vignettes, we use a precalculated tagMatrix
# # data("tagMatrixList")
# # tagMatrix <- tagMatrixList[[4]]

# ### Heatmap of ChIP binding to TSS regions

# tagHeatmap(tagMatrix)

# # The following function will generate the same figure as above.
# peakHeatmap(peak, TxDb=txdb, upstream=3000, downstream=3000)

# # Users can use nbin parameter to speed up.
# peakHeatmap(peak,TxDb = txdb,nbin = 800,upstream=3000, downstream=3000) # or,
# # tagHeatmap(getTagMatrix(peak, windows=getPromoters(TxDb=txdb, upstream=3000, downstream=3000),nbin = 800))

# # Users can also use ggplot method to change the details of the figures.
# peakHeatmap(peak,TxDb = txdb,nbin = 800,upstream=3000, downstream=3000) +
#   scale_fill_distiller(palette = "RdYlGn")
# # tagHeatmap(getTagMatrix(peak, windows=getPromoters(TxDb=txdb, upstream=3000, downstream=3000),nbin = 800)) +
# #   scale_fill_distiller(palette = "RdYlGn")

# # Users can also profile genebody regions
# peakHeatmap(peak = peak,
#             TxDb = txdb,
#             upstream = rel(0.2),
#             downstream = rel(0.2),
#             by = "gene",
#             type = "body",
#             nbin = 800)

# # compare two sets of regions
# # txdb1 <- transcripts(TxDb.Hsapiens.UCSC.hg19.knownGene)
# # txdb2 <- unlist(fiveUTRsByTranscript(TxDb.Hsapiens.UCSC.hg19.knownGene))[1:10000,]
# txdb1 <- transcripts(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
# txdb2 <- unlist(fiveUTRsByTranscript(TxDb.Dmelanogaster.UCSC.dm6.ensGene))[1:10000,]

# region_list <- list(geneX = txdb1, geneY = txdb2)
# peakHeatmap_multiple_Sets(peak = peak,
#                           upstream = 1000,downstream = 1000,
#                           by = c("mAChR-A","brp"),
#                           type = "start_site",
#                           TxDb = region_list,nbin = 800)

# # plot heatmap and peak profile together
# peak_Profile_Heatmap(peak = peak,
#                      upstream = 1000,
#                      downstream = 1000,
#                      by = "gene",
#                      type = "start_site",
#                      TxDb = txdb,
#                      nbin = 800)

# # compare multiple region sets with heatmap and peak profile
# txdb1 <- transcripts(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
# txdb2 <- unlist(fiveUTRsByTranscript(TxDb.Dmelanogaster.UCSC.dm6.ensGene))[1:10000,]

# region_list <- list(geneX = txdb1, geneY = txdb2)
# peak_Profile_Heatmap(peak = peak,
#                      upstream = 1000,
#                      downstream = 1000,
#                      by = c("mAChR-A","brp"),
#                      type = "start_site",
#                      TxDb = region_list,nbin = 800)

# ### Average Profile of ChIP peaks binding to TSS region

# plotAvgProf(tagMatrix, xlim=c(-3000, 3000),
#             xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")

# # The following command will generate the same figure as shown above.
# plotAvgProf2(peak, TxDb=txdb, upstream=3000, downstream=3000, conf = NA,
#              xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")

# # Confidence interval estimated by bootstrap method is also supported for characterizing ChIP binding profiles.
# plotAvgProf(tagMatrix, xlim=c(-3000, 3000), conf = 0.95, resample = 1000)

# ### Profile of ChIP peaks binding to different regions
# ### Binning method for profile of ChIP peaks binding to TSS regions
# ## The results of binning method and normal method are nearly the same. 
# tagMatrix_binning <- getTagMatrix(peak = peak, TxDb = txdb, 
#                                   upstream = 3000, downstream = 3000, 
#                                   type = "start_site", by = "gene", 
#                                   weightCol = "V5", nbin = 800)

# # Profile of ChIP peaks binding to body regions

# ## Here uses `plotPeakProf2` to do all things in one step.
# ## Gene body regions having lengths smaller than nbin will be filtered
# ## A message will be given to warning users about that.
# ## >> 9 peaks(0.872093%), having lengths smaller than 800bp, are filtered...

# ## the ignore_strand is FALSE in default. We put here to emphasize that.
# ## We will not show it again in the below example
# plotPeakProf2(peak = peak, upstream = rel(0.2), downstream = rel(0.2),
#               conf = 0.95, by = "gene", type = "body", nbin = 800,
#               TxDb = txdb, weightCol = "V5",ignore_strand = F)

# # Users can also get the profile ChIP peaks binding to gene body regions with no flank extension or flank extension decided by actual length.
# ## The first method using getBioRegion(), getTagMatrix() and plotPeakProf() to plot in three steps.
# genebody <- getBioRegion(TxDb = txdb,
#                          by = "gene",
#                          type = "body")

# matrix_no_flankextension <- getTagMatrix(peak,windows = genebody, nbin = 800)

# plotPeakProf(matrix_no_flankextension,conf = 0.95)

# ## The second method of using getTagMatrix() and plotPeakProf() to plot in two steps
# matrix_actual_extension <- getTagMatrix(peak,windows = genebody, nbin = 800,
#                                         upstream = 1000,downstream = 1000)
# plotPeakProf(matrix_actual_extension,conf = 0.95)

# # Users can also get the body region of 5UTR/3UTR.
# five_UTR_body <- getTagMatrix(peak = peak, 
#                               TxDb = txdb,
#                               upstream = rel(0.2),
#                               downstream = rel(0.2), 
#                               type = "body",
#                               by = "5UTR",
#                               weightCol = "V5",
#                               nbin = 50)

# plotPeakProf(tagMatrix = five_UTR_body, conf = 0.95)

# ### Profile of ChIP peaks binding to TTS regions

# TTS_matrix <- getTagMatrix(peak = peak, 
#                            TxDb = txdb,
#                            upstream = 3000,
#                            downstream = 3000, 
#                            type = "end_site",
#                            by = "gene",
#                            weightCol = "V5")

# plotPeakProf(tagMatrix = TTS_matrix, conf = 0.95)

# ### Peak Annotation
# peakAnno <- annotatePeak(peak, tssRegion=c(-3000, 3000),
#                          TxDb=txdb, annoDb="org.Dm.eg.db")

# # Transfer chromosome naming styles between ensembl and UCSC
# library(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
# edb <- TxDb.Dmelanogaster.UCSC.dm6.ensGene
# seqlevelsStyle(edb) <- "UCSC"

# peakAnno.edb <- annotatePeak(peak, tssRegion=c(-3000, 3000),
#                              TxDb=edb, annoDb="org.Dm.eg.db")

# # Visualize Genomic Annotation
# plotAnnoPie(peakAnno)
# plotAnnoBar(peakAnno)
# vennpie(peakAnno)
# upsetplot(peakAnno)
# upsetplot(peakAnno, vennpie=TRUE)

# # Visualize distribution of TF-binding loci relative to TSS
# plotDistToTSS(peakAnno,
#               title="Distribution of accessibile chromatin loci\nrelative to TSS")

# # Functional enrichment analysis
# # library(ReactomePA)
# # 
# # pathway1 <- enrichPathway(as.data.frame(peakAnno)$geneId)
# # head(pathway1, 2)
# # 
# # dotplot(pathway1)
# # 
# # gene <- seq2gene(peak, tssRegion = c(-1000, 1000), flankDistance = 3000, TxDb=txdb)
# # pathway2 <- enrichPathway(gene)
# # head(pathway2, 2)
# # 
# # dotplot(pathway2)

# ### ChIP peak data set comparison
# ### Profile of several ChIP peak data binding to TSS region
# # Average profiles

# peak1 <- readPeakFile(files[[1]])
# peak1
# seqlevelsStyle(peak1) <- "UCSC"
# peak1 <- subset(peak1, seqnames == c('chr2L','chr2R','chr3L','chr3R','chr4','chrX','chrY'))
# peak1

# peak2 <- readPeakFile(files[[2]])
# peak2
# seqlevelsStyle(peak2) <- "UCSC"
# peak2 <- subset(peak2, seqnames == c('chr2L','chr2R','chr3L','chr3R','chr4','chrX','chrY'))
# peak2

# peak3 <- readPeakFile(files[[3]])
# peak3
# seqlevelsStyle(peak3) <- "UCSC"
# peak3 <- subset(peak3, seqnames == c('chr2L','chr2R','chr3L','chr3R','chr4','chrX','chrY'))
# peak3

# peak4 <- readPeakFile(files[[4]])
# peak4
# seqlevelsStyle(peak4) <- "UCSC"
# peak4 <- subset(peak4, seqnames == c('chr2L','chr2R','chr3L','chr3R','chr4','chrX','chrY'))
# peak4

# peakList <- list(peak1, peak2, peak3, peak4)

# promoter <- getPromoters(TxDb=txdb, upstream=3000, downstream=3000)
# tagMatrixList <- lapply(peakList, getTagMatrix, windows=promoter)

# ## to speed up the compilation of this vigenette, we load a precaculated tagMatrixList
# # data("tagMatrixList")
# # plotAvgProf(tagMatrixList, xlim=c(-3000, 3000))

# plotAvgProf(tagMatrixList, xlim=c(-3000, 3000), conf=0.95,resample=500, facet="row")

# ## normal method
# plotPeakProf2(peakList, upstream = 3000, downstream = 3000, conf = 0.95,
#               by = "gene", type = "start_site", TxDb = txdb,
#               facet = "row")

# ## binning method 
# plotPeakProf2(peakList, upstream = 3000, downstream = 3000, conf = 0.95,
#               by = "gene", type = "start_site", TxDb = txdb,
#               facet = "row", nbin = 800)

# # Peak heatmaps
# tagHeatmap(tagMatrixList)

# # Profile of several ChIP peak data binding to body region
# plotPeakProf2(peakList, upstream = rel(0.2), downstream = rel(0.2),
#               conf = 0.95, by = "gene", type = "body",
#               TxDb = txdb, facet = "row", nbin = 800)

# # ChIP peak annotation comparision
# peakAnnoList <- lapply(peakList, annotatePeak, TxDb=txdb,
#                        tssRegion=c(-3000, 3000), verbose=FALSE)

# plotAnnoBar(peakAnnoList)

# plotDistToTSS(peakAnnoList)

# # Functional profiles comparison
# genes = lapply(peakAnnoList, function(i) as.data.frame(i)$geneId)
# names(genes) = sub("_", "\n", names(genes))
# compKEGG <- compareCluster(geneCluster   = genes,
#                            fun           = "enrichKEGG",
#                            pvalueCutoff  = 0.05,
#                            pAdjustMethod = "BH")
# dotplot(compKEGG, showCategory = 15, title = "KEGG Pathway Enrichment Analysis")

# # Overlap of peaks and annotated genes
# genes= lapply(peakAnnoList, function(i) as.data.frame(i)$geneId)
# vennplot(genes)

# ### Statistical testing of ChIP seq overlap
# # Shuffle genome coordination
# p <- GRanges(seqnames=c("chr2L", "chr3L"),
#              ranges=IRanges(start=c(1, 100), end=c(50, 130)))
# shuffle(p, TxDb=txdb)

# # Peak overlap enrichment analysis
# enrichPeakOverlap(queryPeak     = peak3,
#                   targetPeak    = peak1,
#                   TxDb          = txdb,
#                   pAdjustMethod = "BH",
#                   nShuffle      = 50,
#                   chainFile     = NULL,
#                   verbose       = FALSE)

# ### Data Mining with ChIP seq data deposited in GEO
# # GEO data collection
# getGEOspecies()
# getGEOgenomeVersion()

# hg19 <- getGEOInfo(genome="hg19", simplify=TRUE)
# head(hg19)

# # Download GEO ChIP data sets
# downloadGEObedFiles(genome="hg19", destDir="hg19")

# gsm <- hg19$gsm[sample(nrow(hg19), 10)]
# downloadGSMbedFiles(gsm, destDir="hg19")

# # Overlap significant testing
# ###


# sessionInfo()



