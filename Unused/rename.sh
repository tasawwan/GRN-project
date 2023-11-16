
# Specify the directory containing the files
# Loop through the files in the directory
for i in $(ls);
do
new_name="${i}.bam"
mv "${i}" "${new_name}"
done