#!/bin/bash
#SBATCH -J run gConvert
#SBATCH -o slurm/gConvert-%j.out
#SBATCH -e slurm/gConvert-%j.err
#SBATCH -n 8
#SBATCH -t 12:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

## This script generates a summary spreadsheet of the IDR peaks

module load R/4.1.0
module load gcc/10.2 pcre2/10.35 intel/2020.2 texlive/2018

R --vanilla < ~/scripts/GRN_project/chip-seq/summary_generator.R
