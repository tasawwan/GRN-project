#This production pipeline aims to mirror as closely as possible the NGS processing steps found in the Reddington Lineage resolved paper.
#Start in the directory you want your files to live and follow the instructions closely.

#Step 0: Prelim steps.
#Make depository for output files. 
# mkdir slurm

#Ensure you have the dm3 reference prepared. 
# mkdir ~/data/dm3
# mkdir ~/data/dm3/bowtie2_index
# cd  ~/data/dm3/bowtie2_index
# wget https://www.encodeproject.org/files/dm3/@@download/dm3.fasta.gz
# module load bowtie2/2.3.5.1
# bowtie2-build ~/scratch/dm3/dm3.fasta.gz dm3

#Create conda environment according to specifications.
# module load anaconda/latest
# conda create --name reddington
# conda activate reddington
# conda install -c bioconda bioconductor-deseq2
# conda install -c bioconda je-suite

#Step 1: Run 1_fqdownloadlist.sh
You can adjust the files to be added with your needs.
sbatch ~/scripts/motif_analysis/1_fqdownloadlist.sh

Step 2: Run Quality Control
sbatch ~/scripts/motif_analysis/2_qc.sh

Step 3: Trimming the Files
sbatch ~/scripts/motif_analysis/3_trim.sh

Step 4: Align to reference genome
sbatch ~/scripts/motif_analysis/4_align.sh

Step 5: Filter and sort
sbatch ~/scripts/motif_analysis/5_filtersort.sh

Step 6: Run stats
sbatch ~/scripts/motif_analysis/6_stats.sh

Step 7: Merge technical replicates
sbatch ~/scripts/motif_analysis/7_merge.sh

Step 8: Mark duplicates
sbatch ~/scripts/motif_analysis/8_dupes.sh

Step 9: Index Files
sbatch ~/scripts/motif_analysis/9_index.sh

Step 10: Peak Calling
sbatch ~/scripts/motif_analysis/10_bio_peakcalling.sh

Step 11: IDR on the biological replicates
sbatch ~/scripts/motif_analysis/11_idr_bio.sh

Step 12: Create Pseudo replicates of each biological replicate
sbatch ~/scripts/motif_analysis/12_pseudo.sh

Step 13: Peak call the pseudo replicates
sbatch ~/scripts/motif_analysis/13_pseudo_peakcalling.sh

Step 14: Run IDR on the pseudo replicates
sbatch ~/scripts/motif_analysis/14_idr_pseudo.sh

Step 15: Merge the biological replicates and create pseudo replicates (merged pseudo)
sbatch ~/scripts/motif_analysis/15_mergepseudo.sh

Step 16: Peak call the merged psuedos
sbatch ~/scripts/motif_analysis/16_mpseudo_peakcalling.sh

Step 17: Run IDR on the merged pseudos
sbatch ~/scripts/motif_analysis/17_idr_mpseudo.sh

Step 18: Quality check to see how well the various psuedos overlap with the biological replicates 
sbatch ~/scripts/motif_analysis/18_intersect.sh

Step 19: Subtract to only get 8-10 hours only
sbatch ~/scripts/motif_analysis/19_newneuron.sh

Step 20: Window for synaptic genes only 3k, 10k, and 50k away
sbatch ~/scripts/motif_analysis/20_window.sh

Step 21: Run Motif analysis in homer
sbatch ~/scripts/motif_analysis/21_motif_homer.sh



###FINALIZE FROM HERE FOR THE OTHER IDR OUTPUTS

#IDR output

    #Bio as the two samples

    #Each bio individually, shuffle, split and run as fake replicates. Run it twice because two bio replicates.
  
    #Merged bio, shuffle, split. Two full fake replicates.



#Try it with merged bio the shuffle split. The half size replicates might have too small a read count.


####It's not working because of the header, don't add a header, just resort with samtools. 


# [terahman@login008 top100k_narrowPeak]$ ls -l
# total 19631
# -rw-r--r-- 1 terahman larschan 5233443 Aug 11 11:12 ERR3975815_ERR3975819_00_top100k_peaks.narrowPeak
# -rw-r--r-- 1 terahman larschan 5237641 Aug 11 11:14 ERR3975815_ERR3975819_01_top100k_peaks.narrowPeak

######Where did this come from?

#We can go back and look at black regions of the genome, a lot of stuff align anyways. Skips over it in peak calling. Ignore that for now though.

#Just ignore the IDR threshold.


#Notes 8/21
#Compare the mpseudo and the individual pseudo to compare peaks with and make sure they overlap.
#Use bedtools intersect

#Bio as the two samples is the main, the other 3 are the controls
#Basically counting how many peaks in bio and the 3 controls, how many peaks in bio as 2 overlap with peak in controls
#Any peak that doesn't overlap with control set is less trustworthy

#Intersect is just a qc step to allow us to run with just the bio replicates

#Use wa and sortout

#Ignore everything from bedgraph coverage down (look at theirs if we want to see it). Just trying to get optimal peak set then motif analysis.

#Should get 4 optimal peak sets for each timepoint tissue types

#One more set with bedtools intersect -v, take the neurons at 10-12 and intersect 8-10 peaks or accessible in either of the other two tissue types
#After that we have one peak set, just the newly accessible one in that time period and unique to neurons.

#Can do it one more time and do it with the synaptic genes using bedtools window, skip for now. Can choose window size later to pick up new additional motifs and enhancers.

#HOMER for motif analysis, but can compare it using MEME (use both)

#I need:
#HOMER MEME intersect scripts
#Synaptic genes script

# Modify script to run off peak regions and not list of genes
# Gives the higest affinity tf that can bind
# We want a list of locations for the motif
# Length of motif is 8, 10, 12, 15 bps
# dump FASTA to make the fasta file. HOMER uses ucsd genome browser. Gives the file for meme.
# Use findMOTIFs Genome 
#Finding instances of specific motifs, can do this later.


#Notes 9/15
#Mpseudo is broken, the rest works
# Give more memory

#Need to fix the merged pseudo

#What are we comparing it to? Mpseudo vs each individual pseudo vs bio, what is the intersection?
#Compare all three controls first then against the bio or all 4 at the same time?

#We are doing the 3 controls first with interesect. 
#Do the intersect, it will give the total number of intersections.

#Narrowpeak is a bed file. 

#We're going to count the number of peaks.

####Are we doing anything with this comparison
#We are going to order by the bioreps in the score.
    #Can call by chromosome name and start or end number
    #Looking for duplicates
    #Row count and visual inspection
    ## of peaks in intersect/total # of peaks in bioreps
    #Will give us a score between 0 and 1

###He's using the find motifs genome. 

#We need genomic position. Convert the narrow peaks
#need to install it on my home directory

#This outputs a bed file, homer requires a text file. Where does that come from?

#Use HOMER to dump fasta and put in MEME


#Homer looks into the regions of the peaks, and they look for regions that are more common than we expect to find
#Do we know any of those sequences
#Gives a list of Sequences that are found in the region and says how conserved it is, tells what trancription factors are likely to bind to it


#Before going to homer we do a subtraction everything else from neurons 10 - 12, we really just want to look at what changed.


#NOTES 9/25
# Fixed 15_mergepseudo
# Reran pseudo
#Installed homer
#The intersect gives more items than before, 16k vs 5k in bioreps alone. When I do the -r -f thing it gives 0 intersect.
#How do we get the genome IDs for HOMER input file.
#Use columns 1, 2, 3, 6

# We only care about the new peaks at 10-12, and will smaller subset to near synaptic genes


#Final production:
#Steps 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19

#Notes 10/4
#The sequences we look at aren't necessarily a multiple of 40, we might have to cut the tail before plugging into meme
#We're going to use bedtools window to keep any of the peaks within a certain distance of synaptic genes, 3000 bp away (.5 to 1 gene away)
#Window first then rerun homer with those peaks left over. Will use the symbols not Gene list
# UCSC Genome browser, table browser.
# Bedtools window with the file we made in table browser. Very similar to intersect.

#For the poster, we can put on:
#The number of peaks we found at 10 to 12, the number of those peaks that were unique at 10 to 12.
#Among those peaks we found these motifs which these transcriptions factors can bind which could be regulating the genes turning on.
#Then subset to synaptic genes to say which peaks are within 3000 bps of synaptic genes, motifs found to those regions that regulate the synaptic genes.
#Model of what TFs are turning on when embryos start to form synapses
#Future Directions: To validate this with knockout or knockdown experiments and see how it affects RNA transcription of synaptic genes and synpatic growth

#For wet lab, contact Gunjun. Disecting larlval brain for RNA and ATAC-seq.
#After that we can do larval NMJ dissections

#We will start single cell data after James returns.
#For computational stuff in the meantime, we can stretch the distance. 3k, 10k, 50k from synaptic genes. Gives us an idea of how the enhancer regions work.

#See James Poster
#Can use the first image, the expression pattern of 8 example synaptic genes
#Rewrite intro: Temporal correlation of synaptic genes with chromatin accessibility peaks. Synaptic genes become more open at this timepoint.
#Look within these peaks and say what transcription factor motifs are now accessible.

#Another visual can be the narrowPeak files, go to IGV.org and upload the files to dm3 genome and it will visualize the peak locations

#Intro, methodology, Peaks, Motif block images, Discussion, Acknowledgmentws

#Question for James:
# Interesting Result:

# [terahman@login008 neurons_10to12]$ wc -l *narrowPeak
#   4245 10to12_only.narrowPeak
#   4925 10to12_synaptic_10k.narrowPeak
#   4033 10to12_synaptic_3k.narrowPeak
#   9314 10to12_synaptic_50k.narrowPeak
#  22517 total

# Thoughts? Why should the subsetted ones be bigger?

#Chat GPT says because its counting them multiple times