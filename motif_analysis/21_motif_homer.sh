#!/bin/bash
#SBATCH -J homer_findMotif
#SBATCH -o slurm/homer_findMotif-%j.out
#SBATCH -e slurm/homer_findMotif-%j.err
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 24:00:00
#SBATCH --mem=150G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load perl
module load anaconda/latest
conda init bash
conda activate /users/terahman/anaconda/reddington

mkdir motifs
mkdir motifs/input_files

for i in $(basename -a neurons_10to12/*.narrowPeak) 
do

name=$(basename "$i" .narrowPeak)

echo create input files
awk '{print $1, $2, $3, $6}' "neurons_10to12/$i" > "motifs/input_files/temp.narrowPeak"
#CONVERT SPACES TO TABS
tr ' ' \\t <  motifs/input_files/temp.narrowPeak > motifs/input_files/motif_$name.narrowPeak
rm motifs/input_files/temp.narrowPeak


mkdir motifs/$name

echo run motif search
perl /users/terahman/homer/bin/findMotifsGenome.pl \
    motifs/input_files/motif_$name.narrowPeak \
    dm3 \
    motifs/$name \
    -p 16 \
    -dumpFasta

done

# for i in $(ls *_p.txt)
# do
# name=`echo ${i}| cut -d'.' -f1`

# echo "Run motif search"
# perl /users/jkentro/homer/bin/findMotifs.pl ${i} \
# fly \
# ~/scratch/homer/homer_out/${name}_bgTenNegTen_Homer_out \
# -bg combined0.10-0.10_IDs.txt \
# -start 1000 -end 1000 \
# -dumpFasta

# echo "done"
# done

# perl /users/terahman/homer/bin/changeNewLine.pl "motifs/target.clean..pos"
