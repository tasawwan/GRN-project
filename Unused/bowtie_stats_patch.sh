#!/bin/bash
#SBATCH -J bowtie2
#SBATCH -o slurm/bowtie2-stats-%j.out
#SBATCH -e slurm/bowtie2-stats-%j.err
#SBATCH -n 18
#SBATCH -t 24:00:00
#SBATCH --mem=50G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load bowtie2/2.3.5.1
module load samtools/1.9

# edit sample names to match your file names prior to _1_val_1.fq.gz
# script can remove intermediate .sam files, uncomment the line

mkdir aligned/positionSorted

for i in $(basename -a trimmed/*_1_val_1.fq.gz); do

  echo sort ${i:0:10}.sam
  samtools sort -@ 24 -o aligned/positionSorted/${i:0:10}.sorted.bam aligned/${i:0:10}.sam &  

done

wait

for i in $(basename -a trimmed/*_1_val_1.fq.gz); do

  echo check bam file ${i:0:10}
  samtools flagstat aligned/positionSorted/${i:0:10}.sorted.bam > aligned/positionSorted/${i:0:10}.sorted.bam.flagstat.txt &

done

# for i in $(basename -a *_1_val_1.fq.gz); do

#   echo index bam file ${i:0:10}
#   samtools index -b aligned/positionSorted/${i:0:10}.sorted.bam aligned/positionSorted/${i:0:10}.sorted.bam.bai &

# done

for i in $(basename -a trimmed/*_1_val_1.fq.gz); do

  echo idxstats bam file ${i:0:10}
  samtools idxstats aligned/positionSorted/${i:0:10}.sorted.bam > aligned/positionSorted/${i:0:10}.sorted.bam.idxstats.txt &

#  echo removing sam file ${i}.sample
#  rm aligned/${i}.sam
done

wait

cd aligned/positionSorted/
module load MultiQC/1.0
echo multiqc
multiqc .

mkdir reports
mv *.html reports
mv *.txt reports
mv *.zip reports

wait
echo Finished execution at `date`






