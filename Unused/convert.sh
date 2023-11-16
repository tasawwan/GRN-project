#!/bin/bash
#SBATCH -J convert
#SBATCH -c 24
#SBATCH -t 24:00:00
#SBATCH --mem=50G
#SBATCH --mail-type=END
#SBATCH -o convert-%j.out
#SBATCH -e convert-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load bwa/0.7.15
#Converting Files (AFTER I RUN THIS PUT AT THE END OF THE BWA SCRIPT, ALSO RUN RENAME FIRST)
#BWA returns SAI files, this is not a standard file format

for i in $(ls *_1.sai)
do
echo "convert ${i}"
id=${i:0:10}
bwa sampe ~/scratch/dm3/dm3.fasta.gz ~/scratch/alligned_sai/"${id}_1.sai" ~/scratch/alligned_sai/"${id}_2.sai" ~/scratch/trimmed/"${id}_1_val_1.fq.gz" ~/scratch/trimmed/"${id}_2_val_2.fq.gz" > "${id}.sam" &
done

wait
mv *.sam ~/scratch/merged_sam

#Run this in the directory where your sai input files are
