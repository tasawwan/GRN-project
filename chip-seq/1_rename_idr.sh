#!/bin/bash
#SBATCH -J rename_idr
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -t 24:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=END
#SBATCH -o slurm/rename_idr-%j.out
#SBATCH -e slurm/rename_idr-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu

cd idr_intersect
mv ERR3975815_ERR3975819-ERR3975833_ERR3975864_intersect.narrowPeak neurons_10to12.narrowPeak
mv ERR3975825_ERR3975848-ERR3975862_ERR3975871_intersect.narrowPeak non.narrowPeak
mv ERR3975830_ERR3975879-ERR3975820_ERR3975827_intersect.narrowPeak neurons_8to10.narrowPeak
mv ERR3975860_ERR3975869-ERR3975846_ERR3975875_intersect.narrowPeak meso.narrowPeak