#!/bin/bash
#SBATCH -J rename_idr
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -t 1:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=END
#SBATCH -o slurm/rename_idr-%j.out
#SBATCH -e slurm/rename_idr-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu

## This script renames the IDR output files to match the time point names and copies
## the synaptic gene subsets to the directory

# Rename the IDR output files to match the time point names
cd idr_intersect
mv ERR3975815_ERR3975819-ERR3975833_ERR3975864_intersect.narrowPeak neurons_10to12.narrowPeak
mv ERR3975825_ERR3975848-ERR3975862_ERR3975871_intersect.narrowPeak non.narrowPeak
mv ERR3975830_ERR3975879-ERR3975820_ERR3975827_intersect.narrowPeak neurons_8to10.narrowPeak
mv ERR3975860_ERR3975869-ERR3975846_ERR3975875_intersect.narrowPeak meso.narrowPeak

# Copy the synaptic gene subset to IDR
cd ..
cp ../motif_analysis/neurons_10to12/10to12_synaptic_10k.narrowPeak idr_intersect/
cp ../motif_analysis/neurons_10to12/10to12_synaptic_3k.narrowPeak idr_intersect/
cp ../motif_analysis/neurons_10to12/10to12_synaptic_50k.narrowPeak idr_intersect/
