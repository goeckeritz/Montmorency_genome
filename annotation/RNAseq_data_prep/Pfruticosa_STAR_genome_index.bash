#!/bin/sh --login
#SBATCH -J STAR_index
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --mem-per-cpu=16g
#SBATCH --time=24:00:00
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR/STAR_genome_fixed8_index_%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load GCC/7.3.0-2.30  OpenMPI/3.1.1-CUDA
module load STAR/2.7.3a

fruticosa_contigs=/mnt/home/goeckeri/genome_files/fruticosa/fruticosaA.contigs.V4.descending.renamed.fasta

STAR --runThreadN 24 --runMode genomeGenerate --genomeDir /mnt/home/goeckeri/genome_files/fruticosa/STAR_fruticosa_index/ --genomeFastaFiles $fruticosa_contigs


#see Montmorency equivalent of this file for notes