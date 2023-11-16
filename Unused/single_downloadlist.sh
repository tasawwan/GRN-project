#!/bin/bash
#SBATCH -J fqdownload
#SBATCH -c 1
#SBATCH -t 12:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=END
#SBATCH -o fqdownload-%j.out
#SBATCH -e fqdownload-%j.err
#SBATCH --mail-user=tasawwar_rahman@brown.edu


wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975815/ERR3975815_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/005/ERR3975815/ERR3975815_2.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975819/ERR3975819_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR397/009/ERR3975819/ERR3975819_2.fastq.gz