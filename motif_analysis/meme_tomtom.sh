#!/bin/bash
#SBATCH -J MEME-TomTom
#SBATCH -o slurm/MEME-TomTom-%j.out
#SBATCH -e slurm/MEME-TomTom-%j.out
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -t 48:00:00
#SBATCH --mem=20G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load meme/5.3.0
module load mpi/openmpi_4.0.0_gcc
module load perl

mkdir motifs/meme
cd motifs

for i in $(ls */target.fa)
do

name=$(dirname $i)

echo "MEME zoops motif search"
meme ${i} -dna -neg $name/background.fa \
-objfun de -mod zoops -revcomp \
-nmotifs 21 \
-maxw 15 \
-o meme/${name}_meme_zoops_out/

echo "MEME anr motif search"
meme ${i} -dna -neg $name/background.fa \
-objfun de -mod anr -revcomp \
-nmotifs 21 \
-maxw 15 \
-o meme/${name}_meme_anr_out/

echo "TomTom TF search"
tomtom meme/${name}_meme_zoops_out/meme.txt \
~/motif_databases/FLY/*.meme \
-o meme/${name}_tomtom_zoops_out/

tomtom meme/${name}_meme_anr_out/meme.txt \
~/motif_databases/FLY/*.meme \
-o meme/${name}_tomtom_anr_out/

echo "done"
done
