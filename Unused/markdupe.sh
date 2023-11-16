#!/bin/bash
#SBATCH -J markdupe
#SBATCH -c 12
#SBATCH -t 12:00:00
#SBATCH --mem=50G
#SBATCH --mail-type=END
#SBATCH -o markdupe-%j.out
#SBATCH -e markdupe-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load anaconda/latest
conda activate reddington
#installed je suite

#ADD FOR LOOP AFTER CALL

mkdir dupes_marked
mkdir dupes_marked/metrics_files

# for i in $(basename -a aligned/positionSorted/*.sorted.bam)
# do
# echo "markdupes ${i}"
# je markdupes INPUT=aligned/positionSorted/${i} OUTPUT=dupes_marked/${i:0:10}_nodupe.bam METRICS_FILE=dupes_marked/metrics_files/${i:0:10}_metrics MM=2 SLOTS=-1 SLOTS=-2 REMOVE_DUPLICATES=true AS=true &
# done

je markdupes INPUT=aligned/positionSorted/ERR3975815.sorted.bam OUTPUT=dupes_marked/ERR3975815_nodupe.bam METRICS_FILE=dupes_marked/metrics_files/ERR3975815_metrics MM=2 SLOTS=-1 SLOTS=-2 REMOVE_DUPLICATES=true AS=true &


wait