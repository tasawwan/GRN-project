#!/bin/bash
#SBATCH -J bowtie2
#SBATCH -o slurm/bowtie2-view-%j.out
#SBATCH -e slurm/bowtie2-view-%j.err
#SBATCH -n 18
#SBATCH -t 24:00:00
#SBATCH --mem=50G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load samtools/1.9

#mkdir aligned/filtered

for i in $(basename -a aligned/*.sam)
do
echo "filter ${i}"
samtools view -b -q 20 -f 3 -F 524 -o aligned/filtered/${i:0:10}.filtered.bam aligned/${i} &
done
