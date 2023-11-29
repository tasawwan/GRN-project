#!/bin/bash
#SBATCH -J dt_plotHeatmap
#SBATCH -o slurm/plotHeatmap-%j.out
#SBATCH -e slurm/plotHeatmap-%j.err
#SBATCH -n 8
#SBATCH -t 48:00:00
#SBATCH --mem=175G
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

mkdir heatmap
mkdir heatmap/center
mkdir heatmap/scale_regions
mkdir heatmap/center/matrices
mkdir heatmap/scale_regions/matrices

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
    sublist=("${TF_array[@]:$i:20}")
    sublists+=("$sublist")
done

count=1

# Make heatmaps using reference point of center
for sublist in "${sublists[@]}"; do
    computeMatrix reference-point --referencePoint center -a 1000 -b 1000 \
    -S $sublist \
    -R $beds \
    --binSize 50 \
    -o heatmap/center/matrix$count.mat.gz \
    --skipZeros --smartLabels --sortRegions descend

    plotHeatmap -m heatmap/center/matrix$count.mat.gz \
    -out heatmap/center/heatmap$count.png  

    ((count++))
done

count=1

# Make heatmaps using scale-regions
for sublist in "${sublists[@]}"; do
    computeMatrix scale-regions -a 1000 -b 1000 \
    -S $sublist \
    -R $beds \
    --binSize 50 \
    -o heatmap/scale_regions/matrix$count.mat.gz \
    --skipZeros --smartLabels --sortRegions descend

    plotHeatmap -m heatmap/scale_regions/matrix$count.mat.gz \
    -out heatmap/scale_regions/heatmap$count.png  

    ((count++))
done

# Move the matrix files to the matrices directory
mv heatmap/center/*.mat.gz heatmap/center/matrices
mv heatmap/scale_regions/*.mat.gz heatmap/scale_regions/matrices

# Now do this for all TFs
# With reference-points
computeMatrix reference-point --referencePoint center -a 1000 -b 1000 \
-S $TFs \
-R $beds \
--binSize 50 \
-o heatmap/matrix.allTFs.refpoint.mat.gz \
--skipZeros --smartLabels --sortRegions descend

plotHeatmap -m heatmap/matrix.allTFs.refpoint.mat.gz \
-out heatmap/heatmap.allTFs.refpoint.png  

# With scale-regions
computeMatrix scale-regions -a 1000 -b 1000 \
-S $TFs \
-R $beds \
--binSize 50 \
-o heatmap/matrix.allTFs.scaleregions.mat.gz \
--skipZeros --smartLabels --sortRegions descend

plotHeatmap -m heatmap/matrix.allTFs.scaleregions.mat.gz \
-out heatmap/heatmap.allTFs.scaleregions.png  