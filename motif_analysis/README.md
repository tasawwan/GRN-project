# Motif Analysis Pipeline

This production pipeline aims to mirror as closely as possible the NGS processing steps found in the Reddington Lineage resolved paper.

However, we are instead performing motif analysis to identify potential transcription factors being activated in neurons at 10-12 hours.

Start in the directory you want your files to live and run the following commands.

## Step 0: Prelim steps.

1. Make depository for output files. 
    
    ```
    mkdir slurm
    ```

2. Ensure you have the dm3 reference prepared. 
    ```
    mkdir ~/data/dm3

    mkdir ~/data/dm3/bowtie2_index

    cd  ~/data/dm3/bowtie2_index

    wget https://www.encodeproject.org/files/dm3/@@download/dm3.fasta.gz

    module load bowtie2/2.3.5.1

    bowtie2-build ~/scratch/dm3/dm3.fasta.gz dm3
    ```

3. Create conda environment according to specifications.
    ```
    module load anaconda/latest
    conda create --name reddington
    conda activate reddington
    conda install -c bioconda bioconductor-deseq2
    conda install -c bioconda je-suite
    ``` 
   
## Step 1: Run 1_fqdownloadlist.sh
    ```
    sbatch ~/scripts/motif_analysis/1_fqdownloadlist.sh
    ```
- Adjust files to fit your needs

## Step 2: Run Quality Control
```
sbatch ~/scripts/motif_analysis/2_qc.sh
```

## Step 3: Trimming the Files
```
sbatch ~/scripts/motif_analysis/3_trim.sh
```

## Step 4: Align to reference genome
```
sbatch ~/scripts/motif_analysis/4_align.sh
```

## Step 5: Filter and sort
```
sbatch ~/scripts/motif_analysis/5_filtersort.sh
```

## Step 6: Run stats
```
sbatch ~/scripts/motif_analysis/6_stats.sh
```

## Step 7: Merge technical replicates
```
sbatch ~/scripts/motif_analysis/7_merge.sh
```

## Step 8: Mark duplicates
```
sbatch ~/scripts/motif_analysis/8_dupes.sh
```

## Step 9: Index Files
```
sbatch ~/scripts/motif_analysis/9_index.sh
```

## Step 10: Peak Calling
```
sbatch ~/scripts/motif_analysis/10_bio_peakcalling.sh
```

## Step 11: IDR on the biological replicates
```
sbatch ~/scripts/motif_analysis/11_idr_bio.sh
```

## Step 12: Create Pseudo replicates of each biological replicate
```
sbatch ~/scripts/motif_analysis/12_pseudo.sh
```

## Step 13: Peak call the pseudo replicates
```
sbatch ~/scripts/motif_analysis/13_pseudo_peakcalling.sh
```

## Step 14: Run IDR on the pseudo replicates
```
sbatch ~/scripts/motif_analysis/14_idr_pseudo.sh
```

## Step 15: Merge the biological replicates and create pseudo replicates (merged pseudo)
```
sbatch ~/scripts/motif_analysis/15_mergepseudo.sh
```

## Step 16: Peak call the merged psuedos
```
sbatch ~/scripts/motif_analysis/16_mpseudo_peakcalling.sh
```

## Step 17: Run IDR on the merged pseudos
```
sbatch ~/scripts/motif_analysis/17_idr_mpseudo.sh
```

## Step 18: Quality check to see how well the various psuedos overlap with the biological replicates 
```
sbatch ~/scripts/motif_analysis/18_intersect.sh
```

## Step 19: Subtract to only get 8-10 hours only
```
sbatch ~/scripts/motif_analysis/19_newneuron.sh
```

## Step 20: Window for synaptic genes only 3k, 10k, and 50k away
```
sbatch ~/scripts/motif_analysis/20_window.sh
```

## Step 21: Run Motif analysis in homer
```
sbatch ~/scripts/motif_analysis/21_motif_homer.sh
```

## General Notes
- IDR output

    - Bio as the two samples

    - Each bio individually, shuffle, split and run as fake replicates. Run it twice because two bio replicates.
  
    - Merged bio, shuffle, split. Two full fake replicates.