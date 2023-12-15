#!/bin/bash
#SBATCH -J dt_plotHeatmap
#SBATCH -o slurm/plotHeatmap-%j.out
#SBATCH -e slurm/plotHeatmap-%j.err
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 48:00:00
#SBATCH --mem=200G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

## This scripts generates a heatmap of IDR x TF peaks

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

mkdir heatmap
mkdir heatmap/refpoint
mkdir heatmap/scale_regions
mkdir heatmap/refpoint/matrices
mkdir heatmap/scale_regions/matrices
mkdir heatmap/allTFs
mkdir heatmap/allTFs/matrices

# narrowPeak files
beds=$(ls idr_intersect/*.narrowPeak)

# bigWig files as a string of space-separated values
TFs=$(ls chipseq_data/bigwig/*.bigWig)

# Convert the list into an array
TF_array=($TFs)

# Get the length of the array
len=${#TF_array[@]}

# Split the array into sublists each containing 20 files
declare -a sublists=()

for ((i=0; i<$len; i+=20)); do
    sublist="${TF_array[@]:$i:20}"
    sublists+=("$sublist")
done

echo ${sublists[@]}

count=1

# Make heatmaps using reference point of center
for sublist in "${sublists[@]}"; do
    computeMatrix reference-point --referencePoint center -a 1000 -b 1000 \
    -S $sublist \
    -R $beds \
    --binSize 50 \
    -o heatmap/refpoint/matrices/matrix$count.refpoint.mat.gz \
    --skipZeros --smartLabels --sortRegions descend

    plotHeatmap -m heatmap/refpoint/matrices/matrix$count.refpoint.mat.gz \
    -out heatmap/refpoint/heatmap$count.refpoint.png  

    ((count++))
done

count=1

# Make heatmaps using scale-regions
for sublist in "${sublists[@]}"; do
    computeMatrix scale-regions -a 1000 -b 1000 \
    -S $sublist \
    -R $beds \
    --binSize 50 \
    -o heatmap/scale_regions/matrices/matrix$count.scaleregions.mat.gz \
    --skipZeros --smartLabels --sortRegions descend

    plotHeatmap -m heatmap/scale_regions/matrices/matrix$count.scaleregions.mat.gz \
    -out heatmap/scale_regions/heatmap$count.scaleregions.png  

    ((count++))
done

# Now do this for all TFs
# With reference-points
computeMatrix reference-point --referencePoint center -a 1000 -b 1000 \
-S $TFs \
-R $beds \
--binSize 50 \
-o heatmap/allTFs/matrices/matrix.allTFs.refpoint.mat.gz \
--skipZeros --smartLabels --sortRegions descend

plotHeatmap -m heatmap/allTFs/matrices/matrix.allTFs.refpoint.mat.gz \
-out heatmap/allTFs/heatmap.allTFs.refpoint.png  

# With scale-regions
computeMatrix scale-regions -a 1000 -b 1000 \
-S $TFs \
-R $beds \
--binSize 50 \
-o heatmap/allTFs/matrices/matrix.allTFs.scaleregions.mat.gz \
--skipZeros --smartLabels --sortRegions descend

plotHeatmap -m heatmap/allTFs/matrices/matrix.allTFs.scaleregions.mat.gz \
-out heatmap/allTFs/heatmap.allTFs.scaleregions.png