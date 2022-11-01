#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J purge_haplotigs
#SBATCH --time 9:59:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH -o /mnt/ls15/scratch/users/goeckeri/purge_haplotigs/purge_run1_%j

module purge
conda activate purge_haplotigs_NEW

subreads_alignment=/mnt/ls15/scratch/users/goeckeri/purge_haplotigs/mont_subreads_aligned_sorted.bam
polished_assembly=/mnt/home/goeckeri/genome_files/mont/assemblyA/montA_corrected.contigs.V5.fasta

cd /mnt/ls15/scratch/users/goeckeri/purge_haplotigs/

/mnt/home/goeckeri/miniconda3/envs/purge_haplotigs_NEW/bin/purge_haplotigs hist -b $subreads_alignment -g $polished_assembly -t 16

#first had to install a conda environment for purge haplotigs. 
#this step serves to identify cutoffs (by looking at your output histogram) for your 'haploid-level coverage' and 'diploid-level coverage' needed for step 2. 
#Note this pipeline is a real bitch to think about if you're working with a polyploid. 
#Be careful if you are - I think the histogram is sort of forced to adhere to the iconical diploid spectra
