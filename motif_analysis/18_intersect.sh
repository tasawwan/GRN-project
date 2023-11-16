#!/bin/bash
#SBATCH -J intersect
#SBATCH -o slurm/intersect-%j.out
#SBATCH -e slurm/intersect-%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 24:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load bedtools/2.26.0

bio_replicates=(
#Non
ERR3975825_ERR3975848-ERR3975862_ERR3975871
#Neurons
ERR3975815_ERR3975819-ERR3975833_ERR3975864
#Myo
ERR3975860_ERR3975869-ERR3975846_ERR3975875
#Neurons 8-10
ERR3975830_ERR3975879-ERR3975820_ERR3975827)

All=(
#Non
ERR3975825_ERR3975848-ERR3975862_ERR3975871
#Neurons
ERR3975815_ERR3975819-ERR3975833_ERR3975864
#Myo
ERR3975860_ERR3975869-ERR3975846_ERR3975875
#Neurons 8-10
ERR3975830_ERR3975879-ERR3975820_ERR3975827)

mkdir idr_intersect
touch idr_intersect/intersect_report.txt

for i in "${bio_replicates[@]}" 
do

biorep="bioreps/idr_bio/$i.narrowPeak"
pseudo1="pseudo/idr_pseudo/${i%%-*}_pseudoidr.narrowPeak"
pseudo2="pseudo/idr_pseudo/${i#*-}_pseudoidr.narrowPeak"
mpseudo="mpseudo/idr_mpseudo/${i}_mpseudoidr.narrowPeak"

bedtools intersect -a $biorep -b $pseudo1 $pseudo2 $mpseudo -u > idr_intersect/${i}_intersect.narrowPeak
lines_intersect=$(cat idr_intersect/${i}_intersect.narrowPeak | wc -l)
lines_biorep=$(cat $biorep | wc -l)
score=$(bc <<< "scale=2; ($lines_intersect / $lines_biorep) * 100")

echo "Intersection Score for $i: $score% Lines Biorep $lines_biorep. Lines Intersect $lines_intersect." | cat >> idr_intersect/intersect_report.txt
echo Intersection Score for $i: $score% Lines Biorep $lines_biorep. Lines Intersect $lines_intersect.

done

# bedtools intersect -a /bioreps/idr_bio/ERR3975815_ERR3975819-ERR3975833_ERR3975864.narrowPeak -b /pseudo/idr_pseudo/${i%%-*}_pseudoidr.narrowPeak $pseudo2 $mpseudo
#This is giving more peaks than before
#NEED TO FIX