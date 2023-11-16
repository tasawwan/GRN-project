#!/bin/bash
#SBATCH -J filter_sort
#SBATCH -o slurm/filtersort-%j.out
#SBATCH -e slurm/filtersort-%j.err
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 48:00:00
#SBATCH --mem=75G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load samtools/1.9

mkdir filtered

for i in $(basename -a aligned/*.sam)
do
echo "filter ${i}"
samtools view -b -q 20 -f 3 -F 524 -@ 16 -o filtered/${i:0:10}.filtered.bam aligned/${i}
done

wait

mkdir positionSorted

for i in $(basename -a filtered/*.bam); do
echo sort ${i}
samtools sort -@ 16 -o positionSorted/${i:0:10}.sorted.bam filtered/${i} 
done

wait

