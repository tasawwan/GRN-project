#!/bin/bash
#SBATCH -J generate_summary
#SBATCH -o slurm/generate_summary-%j.out
#SBATCH -e slurm/generate_summary-%j.err
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 1:00:00
#SBATCH --mem=1G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

## This script generates a summary spreadsheet of the IDR peaks

module load R/4.1.0
module load gcc/10.2 pcre2/10.35 intel/2020.2 texlive/2018

R --vanilla < ~/scripts/GRN_project/chip-seq/summary_generator.R
