#!/bin/bash
#SBATCH -J stats
#SBATCH -o slurm/stats-%j.out
#SBATCH -e slurm/stats-%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 48:00:00
#SBATCH --mem=50G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load samtools/1.9

mkdir positionSorted/reports

#You cannot multithread using & with samtools.

for i in $(basename -a positionSorted/*.sorted.bam); do

  echo check bam file ${i}
  samtools flagstat positionSorted/${i} > positionSorted/reports/${i:0:10}.flagstat.txt

done

# for i in $(basename -a *_1_val_1.fq.gz); do

#   echo index bam file ${i:0:10}
#   samtools index -b aligned/positionSorted/${i:0:10}.sorted.bam aligned/positionSorted/${i:0:10}.sorted.bam.bai

# done

for i in $(basename -a positionSorted/*.sorted.bam); do

  echo idxstats bam file ${i}
  samtools idxstats positionSorted/${i} > positionSorted/reports/${i:0:10}.idxstats.txt

#  echo removing sam file ${i}.sample
#  rm aligned/${i}.sam
done

wait

cd positionSorted/reports
module load MultiQC/1.0
echo multiqc
multiqc .

wait
echo Finished execution at `date`
