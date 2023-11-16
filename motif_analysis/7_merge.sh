#!/bin/bash
#SBATCH -J merge
#SBATCH -o slurm/merge-%j.out
#SBATCH -e slurm/merge-%j.err
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 48:00:00
#SBATCH --mem=75G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load samtools/1.9

technical_replicates=(
ERR3975825_ERR3975848
ERR3975815_ERR3975819
ERR3975860_ERR3975869
ERR3975830_ERR3975879
ERR3975862_ERR3975871
ERR3975833_ERR3975864
ERR3975846_ERR3975875
ERR3975820_ERR3975827)

#The one on line 15 is the single one

mkdir merged

for i in "${technical_replicates[@]}" 
do
echo merge: ${i%%_*} and ${i#*_}
samtools merge -@ 16 merged/${i}.merged.bam positionSorted/${i%%_*}.sorted.bam positionSorted/${i#*_}.sorted.bam
done

