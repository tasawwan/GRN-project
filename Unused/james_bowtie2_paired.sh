#!/bin/bash
#SBATCH -J bowtie2
#SBATCH -o bowtie2-%j.out
#SBATCH -e bowtie2-%j.err
#SBATCH -n 32
#SBATCH -t 48:00:00
#SBATCH --mem=128G
#SBATCH --mail-type=END
#SBATCH --mail-user=james_kentro@brown.edu
​
module load bowtie2/2.3.5.1
module load samtools/1.9
​
# edit sample names to match your file names prior to _1_val_1.fq.gz
# make directories (mkdir) aligned and unaligned
# double check all directory paths
# script removes intermediate .sam files due to their large size, adjust if needed
​
samples=(CGF1_CKDL230013702-1A_H5NTCDSX7_L3
	 CGF2_CKDL230013703-1A_H5NTCDSX7_L3
	 CGF3_CKDL230013704-1A_H5NTCDSX7_L3
	 CGF4_CKDL230013705-1A_H5NTCDSX7_L3
	 CGM1_CKDL230013698-1A_H5NTCDSX7_L3
	 CGM2_CKDL230013699-1A_H5NTCDSX7_L3
	 CGM3_CKDL230013700-1A_H5NTCDSX7_L3
	 CGM4_CKDL230013701-1A_H5NTCDSX7_L3
	 DF1_CKDL230013710-1A_H5NTCDSX7_L4
	 DF2_CKDL230013711-1A_H5NTCDSX7_L4
	 DF3_CKDL230013712-1A_H5NTCDSX7_L4
	 DF4_CKDL230013713-1A_H5NTCDSX7_L4
	 DM1_CKDL230013706-1A_H5NTCDSX7_L3
	 DM2_CKDL230013707-1A_H5NTCDSX7_L4
	 DM3_CKDL230013708-1A_H5NTCDSX7_L4
	 DM4_CKDL230013709-1A_H5NTCDSX7_L4)
​
for i in "${samples[@]}"; do
  bowtie2 -X 1000 -k 10 -q -t -p 32 -x ~/data_koconno5/drosophila_reference_files/dm6/dmel-r6.42 \
  -1 trimmed/${i}_1_val_1.fq.gz \
  -2 trimmed/${i}_2_val_2.fq.gz \
  -S aligned/${i}.sam \
  --un-gz unaligned/${i}.unaligned.fq.gz \
  --very-sensitive
​
  echo sort ${i}.sam
  samtools sort -@ 32 -o aligned/positionSorted/${i}.sorted.bam aligned/${i}.sam
  
  echo check bam file $i
  samtools flagstat aligned/positionSorted/${i}.sorted.bam > aligned/positionSorted/${i}.sorted.bam.flagstat.txt
  
  echo index bam file $i
  samtools index -b aligned/positionSorted/${i}.sorted.bam aligned/positionSorted/${i}.sorted.bam.bai
  
  echo idxstats bam file $i
  samtools idxstats aligned/positionSorted/${i}.sorted.bam > aligned/positionSorted/${i}.sorted.bam.idxstats.txt
  
#  echo removing sam file ${i}.sample
#  rm aligned/${i}.sam
done
​
cd aligned/positionSorted/
module load MultiQC/1.0
echo multiqc
multiqc .
​
 wait
 echo Finished execution at `date`
Collapse

















