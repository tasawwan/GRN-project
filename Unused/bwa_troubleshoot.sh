#!/bin/bash
#SBATCH -J bwa
#SBATCH -c 24
#SBATCH -t 12:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH -o bwa-%j.out
#SBATCH -e bwa-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load bwa/0.7.15

#UNCOMMENT IF DM3 IS NOT LOADED
#DM3 Reference Genome: https://www.encodeproject.org/files/dm3/
#mkdir dm3
#cd dm3
#wget https://www.encodeproject.org/files/dm3/@@download/dm3.fasta.gz
#bwa index dm3.fasta.gz
#cd ..

bwa aln -n 5 -q 20 ../dm3/dm3.fasta.gz -b1 ../trimmed/ERR3975815_1_val_1.fq.gz -b2 ../trimmed/ERR3975815_2_val_2.fq.gz > "ERR3975815.sai"
