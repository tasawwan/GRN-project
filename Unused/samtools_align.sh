#!/bin/bash
#SBATCH -J samtools_align
#SBATCH -c 24
#SBATCH -t 12:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH -o samtools_align-%j.out
#SBATCH -e samtools_align-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load samtools/1.9

mkdir align_index
cd align_index

for i in $(basename -a ../picard_nosamtools/remove_dups/*.bam)
do
echo "align index ${i}"
samtools index -b ../picard_nosamtools/remove_dups/${i} ${i:0:10}.bai &

done

wait
cd ..