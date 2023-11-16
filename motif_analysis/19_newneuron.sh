#!/bin/bash
#SBATCH -J new_neuron
#SBATCH -o slurm/new_neuron-%j.out
#SBATCH -e slurm/new_neuron-%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 24:00:00
#SBATCH --mem=100G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load bedtools/2.26.0

bio_replicates=(
#Non
ERR3975825_ERR3975848-ERR3975862_ERR3975871
#Neurons
ERR3975815_ERR3975819-ERR3975833_ERR3975864
#Myo
ERR3975860_ERR3975869-ERR3975846_ERR3975875
#Neurons 8-10
ERR3975830_ERR3975879-ERR3975820_ERR3975827)

mkdir neurons_10to12
mkdir neurons_10to12/temp
touch neurons_10to12/10to12_only_report.txt


neuronal="bioreps/idr_bio/ERR3975815_ERR3975819-ERR3975833_ERR3975864.narrowPeak"
non="bioreps/idr_bio/ERR3975825_ERR3975848-ERR3975862_ERR3975871.narrowPeak"
myo="bioreps/idr_bio/ERR3975860_ERR3975869-ERR3975846_ERR3975875.narrowPeak"
early_neuronal="bioreps/idr_bio/ERR3975830_ERR3975879-ERR3975820_ERR3975827.narrowPeak"

bedtools subtract -a $neuronal -b $non -A > neurons_10to12/temp/temp1.narrowPeak
bedtools subtract -a neurons_10to12/temp/temp1.narrowPeak -b $myo -A > neurons_10to12/temp/temp2.narrowPeak
bedtools subtract -a neurons_10to12/temp/temp2.narrowPeak -b $early_neuronal -A > neurons_10to12/10to12_only.narrowPeak

late_only=$(cat neurons_10to12/10to12_only.narrowPeak | wc -l)
all_neuronal=$(cat $neuronal | wc -l)
score=$(bc <<< "scale=2; ($late_only / $all_neuronal) * 100")

echo "Intersection Score: $score%. 10 to 12 Only $late_only. All Neuronal $all_neuronal." | cat >> neurons_10to12/10to12_only_report.txt
echo "Intersection Score: $score%. 10 to 12 Only $late_only. All Neuronal $all_neuronal."

rm -r neurons_10to12/temp