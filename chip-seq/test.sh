# bigWig files as a string of space-separated values
TFs=$(ls chipseq_data/bigwig/*.bigWig)

# Convert the list into an array
TF_array=($TFs)
echo ${#TF_array[@]}

# Get the length of the array
len=${#TF_array[@]}

# Split the array into sublists each containing 20 files
declare -a sublists=()
for ((i=0; i<$len; i+=20)); do
    sublist=("${TF_array[@]:$i:20}")
    sublists+=("$sublist")
done

echo ${#sublists[@]}

