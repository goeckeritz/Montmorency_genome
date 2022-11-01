#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J hmmscan
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/hmmscan/hmmscan_array_%j
#SBATCH -a 1-20
#SBATCH --export=INFILE=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/hmmscan/protein_chunks/chunk_names.txt

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load InterProScan/5.33-72.0

FASTA=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE}`
Name=$(echo ${FASTA}| sed 's/\/mnt\/scratch\/goeckeri\/MAKER_P\/fruticosa_run2.maker.output\/hmmscan\/protein_chunks\///')
echo ${Name}

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/hmmscan/

#To get PfamA.hmm:
#wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
#then gunzip the file
#Then, make an index of hmm file before searching the database with your fasta chunks. so before executing line 29, do:
#hmmpress Pfam-A.hmm 

hmmscan --cpu 24 --domE 0.00001 -E 0.00001 --tblout $Name.table /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/hmmscan/Pfam-A.hmm $FASTA

#READ!!!
#USE FASTA-SPLITTER.PL TO SPLIT QUERY PROTEIN FASTA INTO CHUNKS! Makes the process much faster. 
#Then the infile (chunk_names.txt) is simply the full path to each chunk - the number of array jobs submitted is depends on the number of chunks you make with the fasta splitter.
#simply concatenate all resulting output files to make the hmmscan_combined_output, which you will use to get the MAKER standard gene list (your predictions that contain known pfam domains)
#this array job is set up like the RNAseq processing (trimmomatic and star alignments), so see those scripts if you want some more explanation of how it works. 