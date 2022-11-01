#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J ipr_add_functions
#SBATCH --time 96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/add_functions/ipr_functional_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

#after adding the blastp notes to the gff, protein, and transcripts file, we'll add the IPR database reference numbers with a MAKER accessory script
#filter the iprscan.out file BEFORE you do this based on the E value. Run:

#awk 'BEGIN{FS=OFS="\t"}($9<=1.0E-10)' file.tsv > iprscan_Eval_filtered.tsv

#note that this file contains all database information, and is not split into each separate one

cd /mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/add_functions/

post_TE_filtering_apollo_gff_w_blastp_info=/mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/add_functions/fruticosa_postTEs_post_apollo_added_functions.gff3
post_TE_filtering_apollo_proteins_w_blastp_info=/mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/add_functions/fruticosa_postTEs_post_apollo_added_functions_proteins.fasta
post_TE_filtering_apollo_transcripts_w_blastp_info=/mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/add_functions/fruticosa_postTEs_post_apollo_added_functions_transcripts.fasta
ipr_out_all_Eval_filter=/mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/add_functions/fruticosa_filtered.tsv

ipr_update_gff $post_TE_filtering_apollo_gff_w_blastp_info $ipr_out_all_Eval_filter > Pfruticosa_final.gff3


#By the way, you might have noticed the .gff3 file is HUGE. It's cuz there's a lot of unnecessary lines still in there. 
#You can clean up this file with (if it hasn't been done already -- you can do it as early as after TE filtering):
#awk '!($3 == "match" || $3 == "match_part" || $3 == "protein_match" || $3 == "contig" || $3 == "expressed_sequence_match")' Pcer_full_assembly_X.gff3  >  Pcer_full_assembly.gff3


#use agat (https://github.com/NBISweden/AGAT) if you want to extract certain elements from your .gff3 and genome fasta; for example, if you specifically want a CDS fasta.

#yayyyyyyyyyyyyy YA DONE, BOIS
#go do some cooooool comparative genomics!