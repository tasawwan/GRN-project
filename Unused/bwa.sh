#!/bin/bash
#SBATCH -J bwa
#SBATCH -c 24
#SBATCH -t 12:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH -o bwa-%j.out
#SBATCH -e bwa-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load bwa/0.7.15

#UNCOMMENT IF DM3 IS NOT LOADED
#DM3 Reference Genome: https://www.encodeproject.org/files/dm3/
#mkdir dm3
#cd dm3
#wget https://www.encodeproject.org/files/dm3/@@download/dm3.fasta.gz
#bwa index dm3.fasta.gz
#cd ..

mkdir aligned_sai
cd aligned_sai

for i in $(basename -a ../trimmed/*.fq.gz)
do
echo “bwa ${i}”
bwa aln -n 5 -q 20 ../dm3/dm3.fasta.gz ../trimmed/${i} > "${i:0:12}.sai"
done


wait
echo "alignment complete"
cd ..

#Now Convert to different file format
mkdir merged_sam
cd merged_sam

for i in $(basename -a ../aligned_sai/*_1.sai)
do
echo "convert ${i}"
id=${i:0:10}
bwa sampe ../dm3/dm3.fasta.gz ../aligned_sai/"${id}_1.sai" ../aligned_sai/"${id}_2.sai" ../trimmed/"${id}_1_val_1.fq.gz" ../trimmed/"${id}_2_val_2.fq.gz" > "${id}.sam"
done

wait
cd ..