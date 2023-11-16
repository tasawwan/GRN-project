#!/bin/bash
#SBATCH -J fastqc
#SBATCH -N 1
#SBATCH -c 24
#SBATCH -t 12:00:00
#SBATCH --mem=25G
#SBATCH --mail-type=END
#SBATCH -o slurm/fastqc-%j.out
#SBATCH -e slurm/fastqc-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load fastqc/0.11.5
module load MultiQC/1.0

mkdir qc

for i in $(basename -a raw_data/*fastq.gz)
do
echo “qc ${i}”
fastqc raw_data/${i} -o qc &
done

wait

echo "multiqc"
cd qc
multiqc .

#return to original directory (scratch)
cd ..
echo “done”