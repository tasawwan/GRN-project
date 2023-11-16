#!/bin/bash
#SBATCH -J test
#SBATCH -o test
#SBATCH -e test
#SBATCH -t 48:00:00
#SBATCH -c 28   
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu


for i in $(basename -a raw_data/*fastq.gz)
do
echo ${i:0:10}
done

#sbatch ~/scripts/other/test.sh