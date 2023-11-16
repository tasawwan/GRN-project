#!/bin/bash
# Resource request
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 00:10:00
#SBATCH --mem=1G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

# Define array (TASK IDs)
#SBATCH --array=1-16

# Job handling
#SBATCH -J arrayj_trim_adapters
#SBATCH -o %x-%A_%a.out
#SBATCH -e %x-%A_%a.err

# copy this script to the parent directory of your raw_data (e.g. RNAseq/)
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)\

export APPTAINER_BINDPATH="/oscar/home/$USER,/oscar/scratch/$USER,/oscar/data/"
#singularity shell ~/apple.sif
#Removed the above line because it opens a shell and does nothing with it

dir=$(pwd)

id="`sed -n ${SLURM_ARRAY_TASK_ID}p ~/scratch/raw_data/ids`"
pair1=~/scratch/raw_data/"$id"_1.fastq.gz
pair2=~/scratch/raw_data/"$id"_2.fastq.gz

cd ~/scratch/fbOutput
singularity exec ~/apple.sif flexbar -r $pair1 -p $pair2 -ae 2  -ao 3 -at RIGHT -u 100 -t trimmed_$id
#added the exec because the shell wasn't working

mv *.log log_files

cd "$dir"

#Make sure the directories exist
mv *.out ~/scratch/fbOutput/out_err_files
mv *.err ~/scratch/fbOutput/out_err_files


#Testing Example 
#flexbar -r ~/scratch/ERR3975815_1.fastq.gz -p ~/scratch/ERR3975815_2.fastq.gz -ae 2  -ao 3 -at RIGHT -u 100 -t example
#singularity exec ~/apple.sif flexbar -r ~/scratch/ERR3975815_1.fastq.gz -p ~/scratch/ERR3975815_2.fastq.gz -ae 2  -ao 3 -at RIGHT -u 100 -t example