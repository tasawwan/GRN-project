
#THIS SCRIPT IS AN INTEGRATED PROCESSING PIPELINE THAT CAN BE USED FOR MULTIPLE FILES
#IT ASSUMES THAT THE FILES HAVE ALREADY BEEN DOWNLOADED & QCd, YOU SHOULD ALSO HAVE A TEXT FILE CALLED IDS

#START IN THE DIRECTORY WITH THE RAW DATA

id=ERR3975815
sample1=raw_data/${id}_1.fastq.gz
sample2=raw_data/${id}_2.fastq.gz

#TRIMMING
module load trimgalore/0.5.0
module load fastqc/0.11.5
module load cutadapt/1.14

#Note: Wasn't able to specify trim from right

mkdir trimmed
echo tg ${id}
trim_galore --paired raw_data/${id}*.fastq.gz --retain_unpaired --fastqc --stringency 3 -e 0.2 --max_n 100 --output_dir trimmed/${id}

wait 

cd trimmed/

echo clean Up

mkdir unpaired
mv *unpaired* unpaired

mkdir reports
mv *.txt reports

mkdir fastqc_files
mv *fastqc* fastqc_files

cd ..
echo "done"