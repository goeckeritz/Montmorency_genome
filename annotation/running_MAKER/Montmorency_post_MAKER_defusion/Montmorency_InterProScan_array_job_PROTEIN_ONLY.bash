#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J hmmscan
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN_PROTEIN_ONLY.maker.output/post_filtering/hmmscan_array_%j
#SBATCH -a 1-30
#SBATCH --export=INFILE=/mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN_PROTEIN_ONLY.maker.output/post_filtering/protein_chunks/chunk_names.txt

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load InterProScan/5.33-72.0

FASTA=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE}`
Name=$(echo ${FASTA}| sed 's/\/mnt\/scratch\/goeckeri\/montAv5_p99_400k_MAKER\/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN_PROTEIN_ONLY.maker.output\/post_filtering\/protein_chunks\///')
echo ${Name}

cd /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN_PROTEIN_ONLY.maker.output/post_filtering/functional_domains/

#need index of hmm file first. so do:
#hmmpress Pfam-A.hmm 

hmmscan --cpu 12 --domE 0.00001 -E 0.00001 --tblout $Name.table /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/post_filtering/Pfam-A.hmm $FASTA

#Where do I get this PfamA.hmm?
#wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz


#USE FASTA-SPLITTER.PL TO SPLIT QUERY PROTEIN FASTA INTO CHUNKS! See previous trimmomatic and STAR scripts to understand how this array job is run. 
