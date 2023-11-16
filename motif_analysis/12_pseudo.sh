#!/bin/bash
#SBATCH -J pseudo
#SBATCH -o slurm/pseudo-%j.out
#SBATCH -e slurm/pseudo-%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 48:00:00
#SBATCH --mem=150G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu


#CREATING PSEUDOS
module load samtools/1.9

mkdir pseudo
mkdir pseudo/noheader
mkdir pseudo/headers
mkdir pseudo/withheader
mkdir pseudo/sort_index
mkdir pseudo/bam

for i in $(basename -a nodupe/*.nodupe.bam)
do

echo ${i}

nlines=$(samtools view -@ 12 nodupe/${i} | wc -l ) # Number of reads in the BAM file
echo $nlines initial
nlines=$(((nlines + 1) / 2))
echo $nlines split

echo split
samtools view -@ 12 nodupe/${i} | shuf - | split -d -l ${nlines} - "pseudo/noheader/${i:0:21}_noheader_" 
mv pseudo/noheader/${i:0:21}_noheader_00 pseudo/noheader/${i:0:21}_noheader_00.sam
mv pseudo/noheader/${i:0:21}_noheader_01 pseudo/noheader/${i:0:21}_noheader_01.sam

echo make header
samtools view -@ 12 -H nodupe/${i} > pseudo/headers/${i:0:21}_header.sam

echo add header
cat pseudo/headers/${i:0:21}_header.sam pseudo/noheader/${i:0:21}_noheader_00.sam > pseudo/withheader/${i:0:21}_00.sam
cat pseudo/headers/${i:0:21}_header.sam pseudo/noheader/${i:0:21}_noheader_01.sam > pseudo/withheader/${i:0:21}_01.sam

echo sort
samtools sort -@ 12 -o pseudo/sort_index/${i:0:21}_00.sam pseudo/withheader/${i:0:21}_00.sam
samtools sort -@ 12 -o pseudo/sort_index/${i:0:21}_01.sam pseudo/withheader/${i:0:21}_01.sam

echo index
samtools index -@ 12 pseudo/sort_index/${i:0:21}_00.sam -o
samtools index -@ 12 pseudo/sort_index/${i:0:21}_01.sam -o

echo bam
samtools view -bS pseudo/sort_index/${i:0:21}_00.sam > pseudo/bam/${i:0:21}_00.bam
samtools view -bS pseudo/sort_index/${i:0:21}_01.sam > pseudo/bam/${i:0:21}_01.bam

done