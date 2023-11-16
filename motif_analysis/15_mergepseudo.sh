#!/bin/bash
#SBATCH -J mergepseudo
#SBATCH -o slurm/mergepseudo-%j.out
#SBATCH -e slurm/mergepseudo-%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 48:00:00
#SBATCH --mem=150G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu


#CREATING PSEUDOS
module load samtools/1.9

mkdir mpseudo
mkdir mpseudo/merged
mkdir mpseudo/noheader
mkdir mpseudo/headers
mkdir mpseudo/withheader
mkdir mpseudo/sort_index
mkdir mpseudo/bam

bio_replicates=(s
#Non
ERR3975825_ERR3975848-ERR3975862_ERR3975871
#Neurons
ERR3975815_ERR3975819-ERR3975833_ERR3975864
#Myo
ERR3975860_ERR3975869-ERR3975846_ERR3975875
#Neurons 8-10
ERR3975830_ERR3975879-ERR3975820_ERR3975827)

for i in "${bio_replicates[@]}" 
do

echo merge: ${i%%-*} and ${i#*-}
samtools merge -@ 12 mpseudo/merged/${i}.bam nodupe/${i%%-*}.nodupe.bam nodupe/${i#*-}.nodupe.bam

echo ${i}

nlines=$(samtools view -@ 12 mpseudo/merged/${i}.bam | wc -l ) # Number of reads in the BAM file
echo $nlines initial
nlines=$(((nlines + 1) / 2))
echo $nlines split

#THIS ISN"T WORKING
echo split
samtools view -@ 12 mpseudo/merged/${i}.bam | shuf - | split -d -l ${nlines} - "mpseudo/noheader/${i}_noheader_" 
mv mpseudo/noheader/${i}_noheader_00 mpseudo/noheader/${i}_noheader_00.sam
mv mpseudo/noheader/${i}_noheader_01 mpseudo/noheader/${i}_noheader_01.sam

#samtools view -@ 12 * | shuf - | split -d -l 58966844 - "noheader_" 

echo make header
samtools view -@ 12 -H mpseudo/merged/${i}.bam > mpseudo/headers/${i}_header.sam

echo add header
cat mpseudo/headers/${i}_header.sam mpseudo/noheader/${i}_noheader_00.sam > mpseudo/withheader/${i}_00.sam
cat mpseudo/headers/${i}_header.sam mpseudo/noheader/${i}_noheader_01.sam > mpseudo/withheader/${i}_01.sam

echo sort
samtools sort -@ 12 -o mpseudo/sort_index/${i}_00.sam mpseudo/withheader/${i}_00.sam
samtools sort -@ 12 -o mpseudo/sort_index/${i}_01.sam mpseudo/withheader/${i}_01.sam

echo index
samtools index -@ 12 mpseudo/sort_index/${i}_00.sam -o
samtools index -@ 12 mpseudo/sort_index/${i}_01.sam -o

echo bam
samtools view -bS mpseudo/sort_index/${i}_00.sam > mpseudo/bam/${i}_00.bam
samtools view -bS mpseudo/sort_index/${i}_01.sam > mpseudo/bam/${i}_01.bam

done