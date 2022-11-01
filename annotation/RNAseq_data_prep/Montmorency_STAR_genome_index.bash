#!/bin/sh --login
#SBATCH -J STAR_index
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem-per-cpu=16g
#SBATCH --time=24:00:00
#SBATCH -o /mnt/home/goeckeri/genome_files/mont/annotation_prep/montAv5_p99_400k_final/STAR_index_A__%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load GCC/7.3.0-2.30  OpenMPI/3.1.1-CUDA
module load STAR/2.7.3a

montAv5_p99_400k_FULL=/mnt/home/goeckeri/genome_files/mont/annotation_prep/montAv5_p99_400k_final/A__not_A%/montAv5_FULL_FINAL_A__.fasta

STAR --runThreadN 24 --runMode genomeGenerate --genomeDir /mnt/scratch/goeckeri/STAR_index/ --genomeFastaFiles $montAv5_p99_400k_FULL

#before mapping my processed RNAseq reads to the genome, I made an index for the program STAR. 
