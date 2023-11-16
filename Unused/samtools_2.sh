#!/bin/bash
#SBATCH -J samtools_2
#SBATCH -c 24
#SBATCH -t 12:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH -o samtools_2-%j.out
#SBATCH -e samtools_2-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load samtools/1.9
module load MultiQC/1.0

mkdir flagstat
cd flagstat

for i in $(basename -a ../merged_bam/*.bam)
do
echo "check bam file ${i}"
samtools flagstat -@ 2 ../merged_bam/${i} > ${i:0:10}_flagstat.txt &
#This inputs sorted bam file and outputs a flagstat.txt file to check the quality of the alignment
done

wait
cd ..

mkdir idxstats
cd idxstats

for i in ../merged_bam/*.bam
do
filename=$(basename "${i:0:10}")
echo "idxstats bam file ${i}"
samtools idxstats $i > "${filename}_idxstats.txt" &


done

#AFTER THIS RUN THE MULTIQC
wait
multiqc .
#DID NOT RUN MULTIQC ON ANYTHING
cd ..

