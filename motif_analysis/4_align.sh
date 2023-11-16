#!/bin/bash
#SBATCH -J align
#SBATCH -o slurm/align-%j.out
#SBATCH -e slurm/align-%j.err
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 48:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load bowtie2/2.3.5.1
module load samtools/1.9

# edit sample names to match your file names prior to _1_val_1.fq.gz
# script can remove intermediate .sam files, uncomment the line

mkdir aligned
mkdir unaligned

samples=(
#Option A (18-3-150-):
#Non
ERR3975825
ERR3975848
#Neurons
ERR3975815
ERR3975819

#Myo
ERR3975860
ERR3975869
#Neurons 8-10 (18-2-15_8-)
ERR3975830
ERR3975879

#Option B (25-2-150) (Original)
#Non
ERR3975862
ERR3975871
#Neurons
ERR3975833
ERR3975864

#Myo
ERR3975846
ERR3975875

#Neuron 8-10
ERR3975820
ERR3975827
)

#TO USE, YOU MUST CREATE A PROPER INDEX FILE BEFORE HAND
#bowtie2-build ~/scratch/dm3/bowtie2_index/dm3.fasta.gz dm3

for i in "${samples[@]}"
do
  echo bowtie2 ${i}
  bowtie2 -X 1000 -k 10 -q -t -p 32 -x ~/data/terahman/dm3/bowtie2_index/dm3 \
  -1 trimmed/${i}_1_val_1.fq.gz \
  -2 trimmed/${i}_2_val_2.fq.gz \
  -S aligned/${i}.sam \
  --un-gz unaligned/${i}.unaligned.fq.gz \
  --very-sensitive
done