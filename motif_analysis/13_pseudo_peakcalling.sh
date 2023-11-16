#!/bin/bash
#SBATCH -J pseudoreps_peakcalling
#SBATCH -o slurm/pseudopeak-%j.out
#SBATCH -e slurm/pseudopeak-%j.err
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 48:00:00
#SBATCH --mem=20G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load python/3.7.4
module load macs/2.2.6

mkdir pseudo/pseudo_peaks

for i in $(basename -a pseudo/bam/*.bam)
do
echo "Peak calling ${i}"
macs2 callpeak -t pseudo/bam/${i} \
    -g 1.2e8 \
    -p 0.5 \
    -n ${i:0:24} \
    -f BAMPE \
    --keep-dup all \
    --call-summits \
    --extsize 30 \
    --nomodel \
    --nolambda \
    --outdir pseudo/pseudo_peaks
    
    # Get the top 100,000 peaks based on score and save to a new file
sort -k 8nr pseudo/pseudo_peaks/${i:0:24}_peaks.narrowPeak | head -n 100000 > pseudo/pseudo_peaks/${i:0:24}_top100k_peaks.narrowPeak
done

echo clean up

mkdir pseudo/pseudo_peaks/narrowPeak
mkdir pseudo/pseudo_peaks/top100k_narrowPeak
mkdir pseudo/pseudo_peaks/bed
mkdir pseudo/pseudo_peaks/xls
mv pseudo/pseudo_peaks/*_top100k_peaks.narrowPeak pseudo/pseudo_peaks/top100k_narrowPeak
mv pseudo/pseudo_peaks/*.narrowPeak pseudo/pseudo_peaks/narrowPeak
mv pseudo/pseudo_peaks/*.bed pseudo/pseudo_peaks/bed
mv pseudo/pseudo_peaks/*.xls pseudo/pseudo_peaks/xls

echo done