# ChipSeq Analysis Pipeline

This production pipeline is used to analyze the chipseq data around the open regions of chromatin and open regions of chromatin near synaptic genes.

Start in the directory you want your files to live and run the following commands.

## Step 0: Prelim steps.

1. Create the Necessary directories
    ```
    mkdir chipseq
    mkdir chipseq/slurm
    ```

2. Copy the following directories from the motif analysis directory to this chipseq directory.

    - motifs
    - idr_intersect

## Step 1: Download all the chipseq files
```
sbatch ~/scripts/GRN_project/chip-seq/1_chipseq_download.sh 
```

## Step 2: Intersect the IDR against the chipseq data 
```
sbatch ~/scripts/GRN_project/chip-seq/2_intersect.sh 
```

## Step 3: Convert intersection to table
```
sbatch ~/scripts/GRN_project/chip-seq/3_run_gConvert.sh 
```

## Step 4: Create Heatmap
```
sbatch ~/scripts/GRN_project/chip-seq/4_heatmap.sh 
```
