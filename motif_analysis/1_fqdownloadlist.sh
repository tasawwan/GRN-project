#!/bin/bash
#SBATCH -J fqdownload
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -t 12:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=END
#SBATCH -o slurm/fqdownload-%j.out
#SBATCH -e slurm/fqdownload-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu

mkdir raw_data
cd raw_data
samples=(
        #Option A (18-3-15_10-):
        #Non
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975825/ERR3975825_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975825/ERR3975825_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/008/ERR3975848/ERR3975848_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/008/ERR3975848/ERR3975848_2.fastq.gz

        #Neurons (10-12)
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975815/ERR3975815_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975815/ERR3975815_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975819/ERR3975819_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975819/ERR3975819_2.fastq.gz

        #Myo
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/000/ERR3975860/ERR3975860_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/000/ERR3975860/ERR3975860_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975869/ERR3975869_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975869/ERR3975869_2.fastq.gz

        #Neurons 8-10 (18-2-15_8-)
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/000/ERR3975830/ERR3975830_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/000/ERR3975830/ERR3975830_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975879/ERR3975879_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975879/ERR3975879_2.fastq.gz


        #Option B (25-2-15_10) (Original)
        #Non
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/002/ERR3975862/ERR3975862_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/002/ERR3975862/ERR3975862_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/001/ERR3975871/ERR3975871_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/001/ERR3975871/ERR3975871_2.fastq.gz

        #Neurons
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/003/ERR3975833/ERR3975833_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/003/ERR3975833/ERR3975833_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/004/ERR3975864/ERR3975864_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/004/ERR3975864/ERR3975864_2.fastq.gz

        #Myo
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/006/ERR3975846/ERR3975846_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/006/ERR3975846/ERR3975846_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975875/ERR3975875_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975875/ERR3975875_2.fastq.gz

        #Neuron 8-10
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/000/ERR3975820/ERR3975820_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/000/ERR3975820/ERR3975820_2.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/007/ERR3975827/ERR3975827_1.fastq.gz
        ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/007/ERR3975827/ERR3975827_2.fastq.gz)

for i in "${samples[@]}"
do
echo $i
wget $i
done
cd ..