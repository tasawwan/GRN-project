#!/bin/bash
#SBATCH -J idr_mpseudo
#SBATCH -o slurm/idr_mpseudo-%j.out
#SBATCH -e slurm/idr_mpseudo-%j.err
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 5:00:00
#SBATCH --mem=50G
#SBATCH --mail-type=END
#SBATCH --mail-user=tasawwar_rahman@brown.edu

module load python/3.6.6
module load gcc/6.2  
module load idr/2.0.2
# module load mpi/openmpi_3.1.6_gcc

mkdir mpseudo/idr_mpseudo
mkdir mpseudo/idr_mpseudo/logs
mkdir mpseudo/idr_mpseudo/images

cd mpseudo/idr_mpseudo

for i in $(basename -a ../bam/*00.bam) 
do
echo idr pseudo ${i:0:43}
idr --samples ../mpseudo_peaks/top100k_narrowPeak/${i:0:43}_00_top100k_peaks.narrowPeak ../mpseudo_peaks/top100k_narrowPeak/${i:0:43}_01_top100k_peaks.narrowPeak \
    --input-file-type narrowPeak \
    --output-file ${i:0:43}_mpseudoidr.narrowPeak \
    --rank p.value \
    --only-merge-peaks \
    --log-output-file ${i:0:43}.idr.log

#--idr-threshold .05 \
#####No peaks passed this threshold, no peaks pass any threshold.
done

for i in $(basename -a ../bam/*00.bam) 
do
echo idr pseudo plot ${i:0:43}
idr --samples ../mpseudo_peaks/top100k_narrowPeak/${i:0:43}_00_top100k_peaks.narrowPeak ../mpseudo_peaks/top100k_narrowPeak/${i:0:43}_01_top100k_peaks.narrowPeak \
    --input-file-type narrowPeak \
    --output-file ${i:0:43}_mpseudoidr.temp \
    --rank p.value \
    --plot

mv ${i}_mpseudoidr.temp.png ${i}_mpseudoidr.png

done

mv *.log logs
mv *.png images
rm *.temp

#IGNORE:
# idr --samples ERR3975815_ERR3975819_top100k_peaks.narrowPeak  ERR3975833_ERR3975864_top100k_peaks.narrowPeak \
#     --input-file-type narrowPeak \
#     --rank p.value \
#     --output-file output \
#     --plot \
#     --log-output-file test.idr.log 


#    --dont-filter-peaks-below-noise-mean 
# ^^ USE THIS????

# idr --samples ERR3975815_ERR3975819_top100k_peaks.narrowPeak ERR3975833_ERR3975864_top100k_peaks.narrowPeak \
#     --input-file-type narrowPeak \
#     --rank p.value \
#     --output-file test \
#     --plot \
#     --log-output-file test.idr.log \
#     --verbose



#THIS WORKS
# idr --samples ERR3975815_ERR3975819_top100k_peaks.narrowPeak ERR3975833_ERR3975864_top100k_peaks.narrowPeak \
#     --input-file-type narrowPeak \
#     --rank p.value \
#     --output-file test3 \
#     --only-merge-peaks \
#     --log-output-file test3.idr.log \
#     --plot

# idr --samples ERR3975815_ERR3975819_top100k_peaks.narrowPeak ERR3975833_ERR3975864_top100k_peaks.narrowPeak \
#     --input-file-type narrowPeak \
#     --output-file test5.narrowPeak \
#     --rank p.value \
#     --plot