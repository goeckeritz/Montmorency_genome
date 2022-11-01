#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J pal2nal
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/pal2nal/pal2nal_%jar

cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/pal2nal/

module purge
conda activate pal2nal


concatenated_cds_seqs=/mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/pal2nal/concatenated_7sp_cds.fa
concatenated_aa_MSAs=/mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/pal2nal/concatenated_MSAs_aa.fa
#ALL PREFIXES MUST BE ADDED TO THE GENE NAMES BECAUSE THEY ARE IN THE MSAs!!!! if we are to use pal2nal, and sequences aren't in the order they are in the MSA, it has to be this way. 
#the number of input sequences of the aa MSAs must match EXACTLY with the number of input sequences of the cds file 

pal2nal.pl $concatenated_aa_MSAs $concatenated_cds_seqs -output fasta > concatenated_7sp_cds_MSAs.fa

#see commands_for_getting_concatenated_cds_seqs.txt for the unix commands I used to generate these files. 
#Output is the concatenated MSA file but now in cds format.  

#Next step, albeit a bit circular, is to subset each orthogroup MSA sequences back into individual orthogroups. See get_indv_orthogroup_cds_fastas#.sh script(s). I probably only left an example, 
#But I had at least 8 of these loops to parallelize the ./get_subset_of_fastas.pl process. 