#export APPTAINER_BINDPATH="/gpfs/home/$USER,/gpfs/scratch/$USER,/gpfs/data/"
#singularity shell ~/apple.sif 

#echo hello
#flexbar

#flexbar -r ~/scratch/ERR3975815_1.fastq.gz -p ~/scratch/ERR3975815_2.fastq.gz -ae 2  -ao 3 -at RIGHT -u 100 -t example

#singularity exec ~/apple.sif echo hello
#flexbar

#The problem is it loads the singularity but doesn't do anything with it. Singularity exec is my best bet.

#id="`sed -n 1p ~/scratch/ids`"
#pair1=~/scratch/"$id"_1.fastq.gz
#pair2=~/scratch/"$id"_2.fastq.gz

#cd ~/scratch/fbOutput
#singularity exec ~/apple.sif flexbar -r $pair1 -p $pair2 -ae 2  -ao 3 -at RIGHT -u 100 -t trimmed_$id

#This works here, can use a for loop instead of an array job

#dir=$(pwd)
#echo "$dir"

id=( $(ls *.sh) )
for i in $id
do
echo ${id[i]}
done