#!/bin/bash
#SBATCH -J bioreps_peakcalling
#SBATCH -o slurm/peak-%j.out
#SBATCH -e slurm/peak-%j.err
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 48:00:00
#SBATCH --mem=20G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load python/3.7.4
module load macs/2.2.6

mkdir bioreps
mkdir bioreps/peaks

for i in $(basename -a nodupe/*.bam)
do
echo "Peak calling ${i}"
macs2 callpeak -t nodupe/${i} \
    -g 1.2e8 \
    -p 0.5 \
    -n ${i:0:21} \
    -f BAMPE \
    --keep-dup all \
    --call-summits \
    --extsize 30 \
    --nomodel \
    --nolambda \
    --outdir bioreps/peaks
    
    # Get the top 100,000 peaks based on score and save to a new file
sort -k 8nr bioreps/peaks/${i:0:21}_peaks.narrowPeak | head -n 100000 > bioreps/peaks/${i:0:21}_top100k_peaks.narrowPeak
done

echo clean up

mkdir bioreps/peaks/narrowPeak
mkdir bioreps/peaks/top100k_narrowPeak
mkdir bioreps/peaks/bed
mkdir bioreps/peaks/xls
mv bioreps/peaks/*_top100k_peaks.narrowPeak bioreps/peaks/top100k_narrowPeak
mv bioreps/peaks/*.narrowPeak bioreps/peaks/narrowPeak
mv bioreps/peaks/*.bed bioreps/peaks/bed
mv bioreps/peaks/*.xls bioreps/peaks/xls

echo done