#!/bin/bash
#SBATCH -J index
#SBATCH -o slurm/index-%j.out
#SBATCH -e slurm/index-%j.err
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 48:00:00
#SBATCH --mem=75G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load samtools/1.9

mkdir index_files

for i in $(basename -a nodupe/*.nodupe.bam)
do
echo index ${i}
samtools index -@ 16 nodupe/${i} index_files/${i:0:21}.bai
done

#Do we want the index to be added to the original BAM files?

