#!/bin/bash
#SBATCH -J window
#SBATCH -o slurm/window-%j.out
#SBATCH -e slurm/window-%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 24:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load bedtools/2.26.0

bedtools window -w 3000 -a ~/data/terahman/synaptic_genes.bed.gz -b neurons_10to12/10to12_only.narrowPeak > neurons_10to12/10to12_only_synaptic_3k.narrowPeak
bedtools window -w 10000 -a ~/data/terahman/synaptic_genes.bed.gz -b neurons_10to12/10to12_only.narrowPeak > neurons_10to12/10to12_only_synaptic_10k.narrowPeak
bedtools window -w 50000 -a ~/data/terahman/synaptic_genes.bed.gz -b neurons_10to12/10to12_only.narrowPeak > neurons_10to12/10to12_only_synaptic_50k.narrowPeak