#!/bin/bash
#SBATCH -J trimgalore
#SBATCH -o trimgalore-%J.out
#SBATCH -e trimgalore-%J.err
#SBATCH -t 48:00:00
#SBATCH -c 32   
#SBATCH --mem=32G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load trimgalore/0.5.0
module load fastqc/0.11.5
module load cutadapt/1.14

# copy all fq.gz files to one directory
# copy this script to the new directory
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

mkdir trimmed

echo "trimming"
trim_galore --paired ~/scratch/*.fastq.gz --retain_unpaired --fastqc \ -e 2 --output_dir trimmed/

echo "multiqc"
cd trimmed/
module load MultiQC/1.0
multiqc .

echo "done"

wait
echo Finished execution at `date`
