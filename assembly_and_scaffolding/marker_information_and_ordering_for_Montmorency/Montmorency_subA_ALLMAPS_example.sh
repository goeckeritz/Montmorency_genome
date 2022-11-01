#!/bin/bash

#first, load all needed modules and then, the jcvi virtual env. concorde, faSize, and liftOver should be in PATH:
module purge
module load icc/2018.1.163-GCC-6.4.0-2.28  OpenMPI/2.1.2
module load Python/3.6.4
module load texlive/20210316

cd /mnt/home/goeckeri/software/jcvi

source jcvi/bin/activate

cd /mnt/home/goeckeri/software/jcvi/ALLMAPS/Pcerasus_ALLMAPS/montAv5_p99_400k/round4/A/

scaffolds=/mnt/scratch/goeckeri/markers_ABC/montAv5_p99_400k/round4/montAv5_p99_400k_chr1-24_round4.fasta

# Prepare ALLMAPS input
python -m jcvi.assembly.allmaps merge subA.txt -o Montx25F1.bed -w weights.txt

# Run ALLMAPS
python -m jcvi.assembly.allmaps path Montx25F1.bed $scaffolds -w weights.txt

#For whatever reason, chr8 would sometimes flip in direction on me. If this happens to you, go to .agp file and fix + or - for the chromosome. Then you need to run these lines
#python -m jcvi.assembly.allmaps build Montx25F1.bed $scaffolds
#python -m jcvi.assembly.allmaps plot Montx25F1.bed chr8

#THESE IDENTICAL COMMANDS WERE RUN FOR SUBA__ AND SUBB AS WELL; BUT EACH SUBGENOME WAS RUN SEPARATELY
#The scaffolds variable is our genome assembly with no unanchored sequence - just chromosome-scale seqs. That variable is the same for each subgenome. 
#subA.txt is our formatted markers_ABC_montAv5_p99_400k_round4.csv file, but ONLY with lines constituting subgenome A
#The header is deleted in subA.txt, and it is comma-delimited.
#so for each run of ALLMAPS, it is the sub[A,A__B].txt file that changes, according to which HiC scaffolds are which subgenome. 
#see the key_HiC_scaffold_to_chromosomes.txt file to know what HiC_scaffold_#s belong to which subgenomes)
