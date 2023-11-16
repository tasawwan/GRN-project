#!/bin/bash
#SBATCH -J dt_plotHeatmap
#SBATCH -o slurm/plotHeatmap-%j.out
#SBATCH -e slurm/plotHeatmap-%j.err
#SBATCH -n 8
#SBATCH -t 24:00:00
#SBATCH --mem=64G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load python
module load numpy
module load matplotlib
module load pysam
module load py2bit
module load numpydoc
module load pybigwig
module load six
module load plotly
module load deeptoolsintervals
module load deeptools

beds=$(ls idr_intersect/*.narrowPeak)
TFs=$(ls chipseq_data/bigwig/*.bigWig)

echo "computeMatrix_reference_point"
computeMatrix reference-point --referencePoint center -a 1000 -b 1000 \
-S $TFs \
-R $beds \
--binSize 50 \
-o matrix.allTFs.refPoint.mat.gz \
--skipZeros --smartLabels --sortRegions descend

plotHeatmap -m matrix.${name}.refPoint.mat.gz \
-out heatmap.allTFs.png  

echo "done"
#Combine narrowpeak
