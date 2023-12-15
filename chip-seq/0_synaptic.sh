#!/bin/bash
#SBATCH -J synaptic
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -t 1:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=END
#SBATCH -o slurm/synaptic-%j.out
#SBATCH -e slurm/synaptic-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu

# Copy the only 10 to 12 peaks to the idr_intersect folder and subset for synaptic genes
cp ../motif_analysis/neurons_10to12/10to12_only.narrowPeak idr_intersect/neurons_10to12_only.narrowPeak

mkdir idr_intersect/synaptic_genes

module load bedtools/2.26.0
bedtools window -w 3000 -a ~/data/terahman/synaptic_genes.bed.gz -b idr_intersect/neurons_10to12_only.narrowPeak > idr_intersect/synaptic_genes/neurons_10to12_only_synaptic_3k.tsv
bedtools window -w 10000 -a ~/data/terahman/synaptic_genes.bed.gz -b idr_intersect/neurons_10to12_only.narrowPeak > idr_intersect/synaptic_genes/neurons_10to12_only_synaptic_10k.tsv
bedtools window -w 50000 -a ~/data/terahman/synaptic_genes.bed.gz -b idr_intersect/neurons_10to12_only.narrowPeak > idr_intersect/synaptic_genes/neurons_10to12_only_synaptic_50k.tsv

module load R/4.1.0
module load gcc/10.2 pcre2/10.35 intel/2020.2 texlive/2018
R --vanilla < ~/scripts/GRN_project/chip-seq/synaptic.R
