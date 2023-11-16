#!/bin/bash
# Resource request
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 00:10:00
#SBATCH --mem=1G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

# copy this script to the parent directory of your raw_data (e.g. RNAseq/)
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)\

export APPTAINER_BINDPATH="/gpfs/home/$USER,/gpfs/scratch/$USER,/gpfs/data/"
#singularity shell ~/apple.sif
#Removed the above line because it opens a shell and does nothing with it

cd ~/scratch/
#singularity exec ~/apple.sif flexbar -r ~/scratch/ERR3975815_1.fastq.gz -p ~/scratch/ERR3975815_2.fastq.gz -ae 2  -ao 3 -at RIGHT -u 100 -t none

#singularity exec ~/apple.sif flexbar -r ~/scratch/ERR3975815_1.fastq.gz -p ~/scratch/ERR3975815_2.fastq.gz -aa TruSeq -ae 2  -ao 3 -at RIGHT -u 100 -t TruSeq
#singularity exec ~/apple.sif flexbar -r ~/scratch/ERR3975815_1.fastq.gz -p ~/scratch/ERR3975815_2.fastq.gz -aa Nextera -ae 2  -ao 3 -at RIGHT -u 100 -t Nexterav2
#singularity exec ~/apple.sif flexbar -r ~/scratch/ERR3975815_1.fastq.gz -p ~/scratch/ERR3975815_2.fastq.gz -aa NexteraMP -ae 2  -ao 3 -at RIGHT -u 100 -t NexteraMP

#These all give error that adapter error should be between 0 and 1
