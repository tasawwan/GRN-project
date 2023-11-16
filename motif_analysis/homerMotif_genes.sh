#!/bin/bash
#SBATCH -J homer_motifGenes
#SBATCH -o homer_motifGenes-%j.out
#SBATCH -e homer_motifGenes-%j.out
#SBATCH -n 16
#SBATCH -t 48:00:00
#SBATCH --mem=128G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

for n in $(ls motif*[!RV].motif)
do
genes=`echo ${n}| cut -d'.' -f1`

echo "Gene scan for each motif"
perl /users/jkentro/homer/bin/findMotifs.pl ~/genelists/iDEP_synapseClusterGenes.txt \
fly \
/users/jkentro/homer_out/motifs/IDs_neuroAll_Homer_out/homerResults \
-start -1000 -end 1000 \
-find ${n} > genes_${genes}.txt

done
echo "done"
