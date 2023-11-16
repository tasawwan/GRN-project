#!/bin/bash
#SBATCH -J samtools
#SBATCH -c 8
#SBATCH -t 12:00:00
#SBATCH --mem=20G
#SBATCH --mail-type=END
#SBATCH -o samtools-%j.out
#SBATCH -e samtools-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load samtools/1.9
module load MultiQC/1.0

#THIS IS IN THE ORIGINAL BOWTIE 2 SCRIPT. IT DOESN'T NEED TO BE REDONE UNLESS ADAPTING TO BWA
# mkdir aligned
# mkdir unaligned
# mkdir aligned/positionSorted

# for i in $(basename -a merged_sam/*.sam); do

#   echo sort ${i:0:10}.sam
#   samtools sort -@ 8 -o aligned/positionSorted/${i:0:10}.sorted.bam merged_sam/${i:0:10}.sam &  

# done

# wait

# for i in $(basename -a merged_sam/*.sam); do

#   echo check bam file ${i:0:10}
#   samtools flagstat aligned/positionSorted/${i:0:10}.sorted.bam > aligned/positionSorted/${i:0:10}.sorted.bam.flagstat.txt &

# done

# for i in $(basename -a merged_sam/*.sam); do

#   echo index bam file ${i:0:10}
#   samtools index -b aligned/positionSorted/${i:0:10}.sorted.bam aligned/positionSorted/${i:0:10}.sorted.bam.bai &

# done

# for i in $(basename -a merged_sam/*.sam); do

#   echo idxstats bam file ${i:0:10}
#   samtools idxstats aligned/positionSorted/${i:0:10}.sorted.bam > aligned/positionSorted/${i:0:10}.sorted.bam.idxstats.txt &

# #  echo removing sam file ${i}.sample
# #  rm aligned/${i}.sam
# done

# wait

# cd aligned/positionSorted/
# module load MultiQC/1.0
# echo multiqc
# multiqc .


#ORIGINAL
#Filter
mkdir filter_bam
cd filter_bam

for i in $(basename -a ../aligned/positionSorted/*.bam)
do
echo "filter ${i}"
samtools view -q 20 -f 3 -F 524 -b ../aligned/positionSorted/"${i}" > "${i:0:10}.bam" &
done

wait
cd ..

echo "now merge technical replicates"
mkdir merged_bam
cd merged_bam

for i in $(basename -a ../filter_bam/*.bam)
do
echo "merge ${i}"
samtools merge -o ${i:0:10}_merged.bam -b ../filter_bam/${i} &
done

wait
cd ..

#I ALREADY DID THIS ON THE ORIGINAL BOWTIE BEFORE THE TECHNICAL MERGE AND FILTER, SHOULD I REDO???

# for i in $(basename -a merged_sam/*.sam); do

#   echo check bam file ${i:0:10}
#   samtools flagstat aligned/positionSorted/${i:0:10}.sorted.bam > aligned/positionSorted/${i:0:10}.sorted.bam.flagstat.txt &

# done

# for i in $(basename -a merged_sam/*.sam); do

#   echo idxstats bam file ${i:0:10}
#   samtools idxstats aligned/positionSorted/${i:0:10}.sorted.bam > aligned/positionSorted/${i:0:10}.sorted.bam.idxstats.txt &

# #  echo removing sam file ${i}.sample
# #  rm aligned/${i}.sam
# done