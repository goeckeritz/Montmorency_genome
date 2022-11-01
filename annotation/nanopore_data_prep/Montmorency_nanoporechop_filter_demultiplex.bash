#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J porechop
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/porechop_filter2_%j

module purge
module use /mnt/home/johnj/software/modulefiles #for step1
#module load GCC/7.3.0-2.30  OpenMPI/3.1.1-CUDA #for step2
#module load Porechop/0.2.4-Python-3.6.6 #for step2
module load nanopack #for step 1

#THIS is step 1
gunzip -c /mnt/scratch/goeckeri/nano_temp/fastq_pass/nanopore_combined.fastq.gz | NanoFilt -l 150 | gzip > /mnt/scratch/goeckeri/nano_temp/fastq_pass/nanopore_combined_150filt.fastq.gz

#THIS is step 2
#porechop -i /mnt/scratch/goeckeri/nano_temp/fastq_pass/nanopore_combined_150filt.fastq.gz -b /mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/ -t 32 -v 2

#I took my raw, combined nanopore cDNA reads and did step 1 - filtered reads that were smaller than 150 bp. 
#then I commented the modules I used for step 1 and uncommented the ones I needed for step 2. 
#Then, I ran porechop to nix any potential remaining adapters. See: https://github.com/rrwick/Porechop