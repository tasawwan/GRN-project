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

module load r/4.2.2
module load gcc/10.2 pcre2/10.35 intel/2020.2 texlive/2018

mkdir ChiPSeeker

files=()
folder="idr_intersect"

for file in $(ls idr_intersect/neurons_10to12_only*.narrowPeak)
do
    file_name=$(basename $file)
    echo $file_name
    files+=("$file_name")
done

R --vanilla --args $folder ${files[@]} < ~/scripts/GRN_project/chip-seq/ChIPseeker.R
