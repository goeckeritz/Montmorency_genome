#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J gypsy_db_TEs_post_MAKER
#SBATCH --time 23:59:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/TE_filtering_hmmscan_gypsy_%j
#SBATCH -a 1-30
#SBATCH --export=INFILE=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/gypsy_hmmscan/protein_chunks_4_gypsy.txt

#downloaded the full gypsy dataset then combined all of the .hmm profiles (5/3/21). https://gydb.org/index.php?title=Collection_HMM
#split the STANDARD proteins fasta file into parts before running this array job. Use the fasta-splitter.pl script 

# the protein_chunks_4_gypsy.txt is just a text file with a full path to each one of your chunks on separate lines

FASTA=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE}`
Name=$(echo ${FASTA}| sed 's/\/mnt\/scratch\/goeckeri\/MAKER_P\/fruticosa_run2.maker.output\/KILL_the_TEs\/gypsy_hmmscan\///')
echo ${Name}

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10
module load InterProScan/5.33-72.0

#once you download the gypsy database, combine all the hmms, then make a .hmm database with hmmpress. Then you can run the commands below. 

gypsy_hmms=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/gypsy_combined.hmm #path to the database
STANDARD_proteins=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2_STANDARD.all.maker.proteins.fasta #protein predictions that have known pfam domains

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/gypsy_hmmscan

hmmscan --cpu 12 --domE 0.00001 -E 0.00001 --tblout ${Name}.table $gypsy_hmms $FASTA

#concatenate the .table files together after the array job finishes. 

#note -- some of the fasta chunks will have no targets matching the gypsy database queries according to the above thresholds. In these cases, the resulting tables for that array job will be EMPTY, which is fine


