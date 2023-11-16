#!/bin/bash
#SBATCH -J trimgalore
#SBATCH -o trimgalore-%J.out
#SBATCH -e trimgalore-%J.err
#SBATCH -t 48:00:00
#SBATCH -c 28   
#SBATCH --mem=200G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load trimgalore/0.5.0
module load fastqc/0.11.5
module load cutadapt/1.14

# adjust directory names to fit your naming pattern
# adjust above (mail-user to your email)

#Make sure a directory called trimmed exists


tg_processing() {
    local i="$1"
    # Your processing logic for each item goes here
    id=$(sed -n "${i}p" ~/scratch/raw_data/ids)
    trim_galore --paired ~/scratch/raw_data/"$id"*.fastq.gz --retain_unpaired --fastqc --stringency 3 -e 0.2 --max_n 100 --output_dir ~/scratch/trimmed/
    
    #-j/--cores 4 didn't work
    #-e 2 wanted error rate between 0 and 1, not number of errors. 2 per 10 base pairs, so .2

}

#wasnt able to specify trim from right

for i in {1..16}; do
    echo "tg ${i}"
    tg_processing "$i" &
done


wait 
echo "multiqc"
cd trimmed/
module load MultiQC/1.0
multiqc .

echo "done"

wait
echo Finished execution at `date`
