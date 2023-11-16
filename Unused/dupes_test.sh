#!/bin/bash
#SBATCH -J markdupe
#SBATCH -c 24
#SBATCH -t 12:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH -o markdupe-%j.out
#SBATCH -e markdupe-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load anaconda/latest
conda init bash
conda activate reddington
#installed je suite

#ADD FOR LOOP AFTER CALL

echo "markdupes ERR3975815_merged.bam"
je markdupes INPUT=merged_bam/ERR3975815_merged.bam OUTPUT=ERR3975815_nodupe.bam METRICS_FILE=ERR3975815_metrics MM=2 SLOTS=-1 SLOTS=-2 REMOVE_DUPLICATES=true AS=true