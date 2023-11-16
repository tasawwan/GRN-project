#!/bin/bash
#SBATCH -J convert_files
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=END
#SBATCH -o slurm/convert_files-%j.out
#SBATCH -e slurm/convert_files-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu

cd chipseq_data

#Move bigwigs to separate directory
mkdir bigwig
mv *.bigWig bigwig