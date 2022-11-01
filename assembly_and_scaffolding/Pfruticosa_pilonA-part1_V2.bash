#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J pilonA_part1_V2
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem=200G
#SBATCH -o /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/pilonA_part1_j%

cd ${SLURM_SUBMIT_DIR}

java -jar -Xmx200G /mnt/home/goeckeri/pilon/pilon-1.23.jar \
--genome /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/fruticosaA.contigs.V2.part-1.fasta \
--threads 20 \
--frags /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frut_assemblyA_contigs_bt2_sorted_V2.bam \
--output fruticosaA_contigs_part1_V3


#This script is for polishing for the second time (i.e., we are producing version 3 of the genome)


#To reduce computational time, the fasta was split into parts with fasta_splitter.pl
#Then each part was polished with pilon separately as a way to parallelize this process. 
#Parts were recombined and illumina reads were again aligned to the assembly to start the polishing cycle over

