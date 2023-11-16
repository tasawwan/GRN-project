# ChipSeq Analysis Pipeline

This production pipeline is used to analyze the chipseq data around the open regions of chromatin and open regions of chromatin near synaptic genes.

Start in the directory you want your files to live and run the following commands.

## Step 0: Prelim steps.

1. Create the Necessary directories
    ```
    mkdir chipseq
    mkdir chipseq/slurm
    ```

2. Copy the necessary files
    ```
    sbatch ~/scripts/GRN_project/chip-seq/0_setup_files.sh 
    ```

## Step 1: Download all the chipseq files

```
sbatch ~/scripts/GRN_project/chip-seq/1_chipseq_download.sh 
```

## Step 2: Intersect the IDR against the chipseq data 
```
sbatch ~/scripts/GRN_project/chip-seq/2_intersect.sh 
```

## Step 3: Create Heatmap (run concurrently with step 2)
```
sbatch ~/scripts/GRN_project/chip-seq/3_heatmap.sh 
```

## Step 4: Convert intersection to table (relies on step 2)
```
sbatch ~/scripts/GRN_project/chip-seq/4_generate_summary.sh 
```