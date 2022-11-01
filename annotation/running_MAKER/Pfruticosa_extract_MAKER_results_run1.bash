#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J extract
#SBATCH --time 9:59:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/maker_extract_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/

#Get the GFFs from all of the directories within the datastore:
gff3_merge -d fruticosa_run1_master_datastore_index.log fruticosa_run1.all.gff 

#Get the fastas from proteins and transcripts!
fasta_merge -d fruticosa_run1_master_datastore_index.log fruticosa_run1.all.maker.proteins.fasta fruticosa_run1.all.maker.transcripts.fasta
