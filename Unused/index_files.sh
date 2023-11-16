touch ids

#Update directory accordingly
for i in ~/scratch/*_1.fastq.gz
do
  filename=$(basename "${i}" "_1.fastq.gz")
  echo "${filename}" >> ids
done



#touch list_of_files_1
#touch list_of_files_2

#for i in $(ls ~/scratch/*_1.fastq.gz)
#do
#  echo ${i} >> list_of_files_1
#done

#for i in $(ls ~/scratch/*_2.fastq.gz)
#do
#  echo ${i} >> list_of_files_2
#done