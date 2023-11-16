#!/bin/bash
#SBATCH -J percent_overlap
#SBATCH -o slurm/percent_overlap-%j.out
#SBATCH -e slurm/percent_overlap-%j.err
#SBATCH -n 8
#SBATCH -t 12:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

#Divide number of lines in the files by the number of lines in the chipseq peak



for i in $(ls idr_intersect/*.narrowPeak); do
    name=$(basename $i .narrowPeak)
    echo $name

    for n in $(ls chipseq_data/bed/*.bed.gz); do
        TF=$(basename $n .bed.gz)
        echo $TF



#Might have to use the R Script because I want to take from the meta data the ascension and experiment target and make a spreadsheet with the # of peaks for each one and the percentage overlap