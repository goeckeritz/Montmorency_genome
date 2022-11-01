#!/bin/sh --login

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10
module load InterProScan/5.33-72.0

#hmmscan/InterProScan of MAKER max protein dataset (the proteins fasta extracted from the second run of maker)
hmmscan_combined_output=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/hmmscan/pfam_out.txt
#can use pfam_out.txt from defusion step4, or use the gypsy hmmscan as a placeholder for this. It really doesn't make that much of a difference. (actually, it was about a difference of 400-500 genes for fruticosa!
#I made this error for the mont TE filtering, but when I reran it with the pfam_out.txt from defusion's step 4, it only identified 6 more TE-related genes. 

#output from first bit of filtering after the second run of MAKER (note, transcripts file isn't listed
STANDARD_gff=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2.all.std.gff
STANDARD_proteins=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2.all.maker.proteins.std.fa
MAKER2_STANDARD_gene_list=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_standard_gene_list
#you'll need to make this ^, see pfam hmmscan job

#databases and files needed for filtering TEs out from the above files
Tpases_blast_output=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/STANDARD_fruticosa_proteins_to_Tpases
gypsy_hmms=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/gypsy_db.hmm
gffcompare_EMPTY=/mnt/home/goeckeri/bugfix_defusion/MAKER_files/final/final_final/final_final_final_post_apollo/standin.refmap #THIS FILE IS EMPTY if you don't work with rice. It's just a placeholder.    
childs_lab_TE_domains=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/TE_Pfam_domains.txt #downloaded from Childs Lab github repository (https://github.com/Childs-Lab/GC_specific_MAKER)
combined_gypsy_pfam_output=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/protein_chunks/fruticosa_run2.all.maker.proteins.std.combined.table #after running hmmscan on standard proteins fasta file chunks, this is the combined (with cat) output of the mini hmmscan chunks against the gypsy hmm database

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/

./create_no_TE_genelist.py --input_file_TEpfam $childs_lab_TE_domains --input_file_maxPfam $hmmscan_combined_output --input_file_geneList_toKeep $MAKER2_STANDARD_gene_list --input_file_TEhmm $combined_gypsy_pfam_output --input_file_TEblast $Tpases_blast_output --input_file_TErefmap $gffcompare_EMPTY --output_file /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2_standard_gene_list_TE_filtered

#Total number of TE-related pfam domains:  181
#Number of TE-related genes after adding blast info:  4089
#Total number of full matches:  0
#Number of TE-related genes after adding refmap info:  4089
#Length of old gene set:  106450
#Length of new gene set:  102361
#All thinks considered, I don't really think this is enough genes to seriously affect any downstream applications. 


