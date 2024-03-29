#!/bin/bash
#SBATCH -J intersect
#SBATCH -o slurm/intersect-%j.out
#SBATCH -e slurm/intersect-%j.err
#SBATCH -n 8
#SBATCH -t 12:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

## This script intersects all my idr peaks with the chipseq TF peaks

module load bedtools

mkdir intersection

for i in $(ls idr_intersect/*.narrowPeak); do
    name=$(basename $i .narrowPeak)
    echo $name

    for n in $(ls chipseq_data/bed/*.bed.gz); do
        TF=$(basename $n .bed.gz)
        echo $TF

        bedtools intersect -wo \
        -sortout \
        -filenames \
        -a ${i} \
        -b ${n} \
        -f 0.30 -F 0.30 \
        -e \
        > intersection/${name}_${TF}.bed

    done

done