#!/bin/bash
#SBATCH -J trim
#SBATCH -o slurm/trim-%J.out
#SBATCH -e slurm/trim-%J.err
#SBATCH -t 24:00:00
#SBATCH -N 1
#SBATCH -c 28   
#SBATCH --mem=50G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load trimgalore/0.5.0
module load fastqc/0.11.5
module load cutadapt/1.14

# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

#Wasn't able to specify trim from right
mkdir trimmed

for i in $(basename -a raw_data/*_1.fastq.gz); 
do
echo "tg ${i:0:10}"
trim_galore --paired raw_data/"${i:0:10}"*.fastq.gz --retain_unpaired --fastqc --stringency 3 -e 0.2 --max_n 100 --output_dir trimmed/ &
done

wait 

echo "multiqc"

cd trimmed/
module load MultiQC/1.0
multiqc .

echo clean Up

mkdir unpaired
mv *unpaired* unpaired

mkdir reports
mv *.txt reports

mkdir fastqc_files
mv *fastqc* fastqc_files

cd ..
echo "done"