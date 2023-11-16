#!/bin/bash
#SBATCH -J dupes
#SBATCH -N 1
#SBATCH -c 16
#SBATCH -t 48:00:00
#SBATCH --mem=75G
#SBATCH --mail-type=END
#SBATCH -o slurm/dupes-%j.out
#SBATCH -e slurm/dupes-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu
# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

module load picard-tools/2.9.2

#For help
#java -jar $PICARD -h

mkdir nodupe
mkdir nodupe/metrics

for i in $(basename -a merged/*.bam)
do
echo "remove duplicates ${i}"
java -jar $PICARD MarkDuplicates \
    I=merged/${i} \
    O=nodupe/${i:0:21}.nodupe.bam \
    M=nodupe/metrics/${i:0:21}.metrics.txt \
    REMOVE_DUPLICATES=true \
    ASSUME_SORTED=true
done


#TEST
#java -jar $PICARD MarkDuplicates \
#    I=ERR3975815_merged.bam \
#    O=test.bam \
#    M=test_metrics.txt \
#    REMOVE_DUPLICATES=true \
#    ASSUME_SORTED=true

#ERROR MESSAGE
# picard.sam.markduplicates.MarkDuplicates INPUT=[ERR3975815_merged.bam] OUTPUT=test.bam METRICS_FILE=test_metrics.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true    MAX_SEQUENCES_FOR_DISK_READ_ENDS_MAP=50000 MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000 SORTING_COLLECTION_SIZE_RATIO=0.25 TAG_DUPLICATE_SET_MEMBERS=false REMOVE_SEQUENCING_DUPLICATES=false TAGGING_POLICY=DontTag DUPLICATE_SCORING_STRATEGY=SUM_OF_BASE_QUALITIES PROGRAM_RECORD_ID=MarkDuplicates PROGRAM_GROUP_NAME=MarkDuplicates READ_NAME_REGEX=<optimized capture of last three ':' separated fields as numeric values> OPTICAL_DUPLICATE_PIXEL_DISTANCE=100 VERBOSITY=INFO QUIET=false VALIDATION_STRINGENCY=STRICT COMPRESSION_LEVEL=5 MAX_RECORDS_IN_RAM=500000 CREATE_INDEX=false CREATE_MD5_FILE=false GA4GH_CLIENT_SECRETS=client_secrets.json
# Executing as terahman@node1747.oscar.ccv.brown.edu on Linux 3.10.0-1160.76.1.el7.x86_64 amd64; OpenJDK 64-Bit Server VM 19.0.2+7-44; Picard version: 2.9.2-SNAPSHOT
# INFO	MarkDuplicates	Start of doWork freeMemory: 35719472; totalMemory: 41943040; maxMemory: 2684354560
# INFO	MarkDuplicates	Reading input file and constructing read end information.
# INFO	MarkDuplicates	Will retain up to 9725922 data points before spilling to disk.
# WARNING	AbstractOpticalDuplicateFinderCommandLineProgram	A field field parsed out of a read name was expected to contain an integer and did not. Read name: ERR3975815.95. Cause: String 'ERR3975815.95' did not start with a parsable number.
