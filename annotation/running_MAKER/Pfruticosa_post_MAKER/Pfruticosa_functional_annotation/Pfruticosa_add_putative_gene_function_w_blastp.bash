#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J blastp_add_functions
#SBATCH --time 96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/add_functions/blastp_functional_%j

module purge
module load GCC/8.2.0-2.31.1  OpenMPI/3.1.3
#module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
#module load MAKER/2.31.10 #load maker after blast stuff. MAKER wasn't compatible with BLAST+/2.9.0. Stupid dependency issues. 
module load BLAST+/2.9.0

#This is another two-step script because I am the embodiment of chaos. 

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/add_functions/

post_TE_filtering_apollo_gff=/mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/fruticosa_postTEs_post_apollo_combined.gff3
post_TE_filtering_apollo_proteins=/mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/fruticosa_postTEs_post_apollo_combined_proteins.fasta
post_TE_filtering_apollo_transcripts=/mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/fruticosa_postTEs_post_apollo_combined_transcripts.fasta

#First, get the Uniprot/Swiss-Prot multi-Fasta file: https://www.uniprot.org/uniprot/?query=reviewed:yes (didn't bother to distinguish plants or humans or whatever. Took it all.)
#Then make the BLAST database for the fasta. The command is super duper fast.  

makeblastdb -in /mnt/home/goeckeri/bugfix_defusion/MAKER_files/final/final_final/final_final_final_post_apollo/rename_add_functional/uniprot_sprot.fasta -input_type fasta -dbtype prot

uniprot_sprot=/mnt/home/goeckeri/bugfix_defusion/MAKER_files/final/final_final/final_final_final_post_apollo/rename_add_functional/uniprot-reviewed_yes.fasta

#blast off!
blastp -db $uniprot_sprot -query $post_TE_filtering_apollo_proteins -out maker2uni.blastp -evalue 0.0000000001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 24

#go here to learn more about these options and what they do. https://www.ncbi.nlm.nih.gov/books/NBK62051/#:~:text=The%20SEG%20program%20is%20used,regions%20in%20nucleic%20acid%20queries.&text=Also%20known%20as%20filtering.
#the -num_alignments 1 and -max_hsps_per_subject 1 flags limit the hits returned for a given sequence to a single line in the BLAST report


#STEP 2
#uncomment the lines below (41,43-46) after the blastp analysis has finished. also uncomment lines 13 and 14, and COMMENT lines 12 and 15. 
#blastp_protein_output=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/add_functions/maker2uni.blastp

#Add the protein homology data to the MAKER GFF3 and FASTA files with maker_functional_gff and maker_functional_fasta
#maker_functional_gff $uniprot_sprot $blastp_protein_output $post_TE_filtering_gff > ./fruticosa_TE_filtered_functional_blastp.gff
#maker_functional_fasta $uniprot_sprot $blastp_protein_output $post_TE_filtering_proteins > ./fruticosa_TE_filtered_functional_blastp_proteins.fasta
#maker_functional_fasta $uniprot_sprot $blastp_protein_output $post_TE_filtering_transcripts > ./fruticosa_TE_filtered_functional_blastp_transcripts.fasta

#blastp info is now added to column 9 of your gff and the headers of your fasta sequences. yayyyyyy

