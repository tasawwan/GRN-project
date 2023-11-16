#!/bin/bash
#SBATCH -J mpseudoreps_peakcalling
#SBATCH -o slurm/mpsuedopeak-%j.out
#SBATCH -e slurm/mpseudopeak-%j.err
#SBATCH -N 1
#SBATCH -n 2
#SBATCH -t 48:00:00
#SBATCH --mem=20G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load python/3.7.4
module load macs/2.2.6

mkdir mpseudo/mpseudo_peaks

for i in $(basename -a mpseudo/bam/*.bam)
do
echo "Peak calling ${i}"
macs2 callpeak -t mpseudo/bam/${i} \
    -g 1.2e8 \
    -p 0.5 \
    -n ${i:0:46} \
    -f BAMPE \
    --keep-dup all \
    --call-summits \
    --extsize 30 \
    --nomodel \
    --nolambda \
    --outdir mpseudo/mpseudo_peaks
    
    # Get the top 100,000 peaks based on score and save to a new file
sort -k 8nr mpseudo/mpseudo_peaks/${i:0:46}_peaks.narrowPeak | head -n 100000 > mpseudo/mpseudo_peaks/${i:0:46}_top100k_peaks.narrowPeak
done

echo clean up

mkdir mpseudo/mpseudo_peaks/narrowPeak
mkdir mpseudo/mpseudo_peaks/top100k_narrowPeak
mkdir mpseudo/mpseudo_peaks/bed
mkdir mpseudo/mpseudo_peaks/xls
mv mpseudo/mpseudo_peaks/*_top100k_peaks.narrowPeak mpseudo/mpseudo_peaks/top100k_narrowPeak
mv mpseudo/mpseudo_peaks/*.narrowPeak mpseudo/mpseudo_peaks/narrowPeak
mv mpseudo/mpseudo_peaks/*.bed mpseudo/mpseudo_peaks/bed
mv mpseudo/mpseudo_peaks/*.xls mpseudo/mpseudo_peaks/xls

echo done

