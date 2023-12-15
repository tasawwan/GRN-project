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


## Rename the IDR output files to match the time point names
cp -r ../motif_analysis/idr_intersect .

cd idr_intersect
mv ERR3975815_ERR3975819-ERR3975833_ERR3975864_intersect.narrowPeak neurons_10to12.narrowPeak
mv ERR3975825_ERR3975848-ERR3975862_ERR3975871_intersect.narrowPeak non.narrowPeak
mv ERR3975830_ERR3975879-ERR3975820_ERR3975827_intersect.narrowPeak neurons_8to10.narrowPeak
mv ERR3975860_ERR3975869-ERR3975846_ERR3975875_intersect.narrowPeak meso.narrowPeak

rm intersect_report.txt

cd ..

# Copy the only 10 to 12 peaks to the idr_intersect folder and subset for synaptic genes
cp ../motif_analysis/neurons_10to12/10to12_only.narrowPeak idr_intersect/neurons_10to12_only.narrowPeak

module load bedtools/2.26.0
bedtools window -w 3000 -a ~/data/terahman/synaptic_genes.bed.gz -b idr_intersect/neurons_10to12_only.narrowPeak > idr_intersect/neurons_10to12_only_synaptic_3k.narrowPeak
bedtools window -w 10000 -a ~/data/terahman/synaptic_genes.bed.gz -b idr_intersect/neurons_10to12_only.narrowPeak > idr_intersect/neurons_10to12_only_synaptic_10k.narrowPeak
bedtools window -w 50000 -a ~/data/terahman/synaptic_genes.bed.gz -b idr_intersect/neurons_10to12_only.narrowPeak > idr_intersect/neurons_10to12_only_synaptic_50k.narrowPeak

# Remove duplicate lines

#cd idr_intersect
#for file in ls; do
#    sort "$file" | uniq > temp_file && mv temp_file "$file"
#done


# take the unique 10 to 12 peaks, then for the bedtools window how many of those peaks are within 3k of a synaptic gene
# In how many of the peaks that are within 3kb of a synaptic gene
