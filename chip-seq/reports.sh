#!/bin/bash
#SBATCH -J tsv_reports
#SBATCH -o slurm/tsv_reports-%j.out
#SBATCH -e slurm/tsv_reports-%j.err
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 1:00:00
#SBATCH --mem=5G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

#This script is intended to manually create tsv files for the number of lines in each file
#This is a substitute for the R scripts just in case I can't figure it out

mkdir reports

#Get the number of lines in the intersection files
for i in $(ls intersection/*.bed); do
   full_name=$(basename $i | cut -d'.' -f1)
   reversed_name=$(echo $full_name | rev)
   accession=$(echo $reversed_name | cut -d'_' -f1 | rev)
   name=$(echo $full_name | rev | cut -d'_' -f2- | rev)
   lines=$(wc -l < "$i")
   echo $name  $accession  $lines >> reports/intersection_report.tsv
done

#Get the number of lines in the regular files
for i in $(ls idr_intersect/*.narrowPeak); do
   name=$(basename $i | cut -d'.' -f1)
   echo $name  $lines >> reports/all_report.tsv
done