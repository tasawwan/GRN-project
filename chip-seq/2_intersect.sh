#!/bin/bash
#SBATCH -J intersect
#SBATCH -o slurm/intersect-%j.out
#SBATCH -e slurm/intersect-%j.err
#SBATCH -n 8
#SBATCH -t 12:00:00
#SBATCH --mem=32G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

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