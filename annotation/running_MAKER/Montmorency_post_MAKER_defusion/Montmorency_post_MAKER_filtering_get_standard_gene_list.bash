#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J 1post_MAKER
#SBATCH --time 3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/generate_standard_gene_list_%j

#these commands are from Bowman et al. 2017 (A modified GC....) - perl scripts are from Childs Lab GitHub repository. 

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

gff3_MAKER2=/mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.all.gff
hmmscan_combined_output=/mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/post_filtering/functional_domains/Pcerasus_run2_montAv5_p99_400k_protein_domains_combined.table
#hmmscan_combined_output is a concatenated table from the protein chunks array job meant to find predictions with known pfam domains. 

cd /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/

#Generate the standard gene list... find the genes that have a known protein domain, in other words. 

./generate_maker_standard_gene_list.pl --input_gff $gff3_MAKER2 --pfam_results $hmmscan_combined_output --pfam_cutoff 0.0000000001 --output_file Pcerasus_run2_montAv5_p99_400k.all.STANDARD.list

#uncomment the lines below to run the next steps. You might be able to run this all in one go. I tend to do things in pieces to watch out for errors. 

MAKER2_standard_gene_list=/mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_run2_montAv5_p99_400k.all.STANDARD.list
transcript_fasta=/mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_run2_montAv5_p99_400k.all.maker.transcripts.fasta
protein_fasta=/mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_run2_montAv5_p99_400k.all.maker.proteins.fasta

./get_subset_of_fastas.pl -l $MAKER2_standard_gene_list -f $transcript_fasta -o Pcerasus_montAv5_p99_400k_STANDARD.all.maker.transcripts.fasta

./get_subset_of_fastas.pl -l $MAKER2_standard_gene_list -f $protein_fasta -o Pcerasus_montAv5_p99_400k_STANDARD.all.maker.proteins.fasta

#Next step - create the new standard gff file (don't uncomment me!)

./create_maker_standard_gff.pl --input_gff $gff3_MAKER2 --output_gff Pcerasus_montAv5_p99_400k_STANDARD.all.gff --maker_standard_gene_list $MAKER2_standard_gene_list

#We have our new STANDARD files. Time to find potential fusions!