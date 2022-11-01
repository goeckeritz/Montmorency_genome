#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J 1post_MAKER
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/Pcerasus_run2_fixed8_v4.maker.output/generate_standard_gene_list2_%j

#these commands are from Bowman et al. 2017 (A modified GC....) - perl scripts are from Childs Lab GitHub repository. 

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

gff3_MAKER2=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2.all.gff
hmmscan_combined_output=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/hmmscan/fruticosa_run2.all.maker.proteins.combined.fasta.table

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/

#Generate the standard gene list... find the genes that have a known protein domain, in other words. 

./generate_maker_standard_gene_list.pl --input_gff $gff3_MAKER2 --pfam_results $hmmscan_combined_output --pfam_cutoff 0.0000000001 --output_file ./fruticosa_run2_standard_gene_list

#uncomment the lines below (and be sure to comment line 24 too) to run the next steps. This uses the standard gene list you made above to extract the 'standard' maker gene set data

#MAKER2_standard_gene_list=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2_standard_gene_list
#transcript_fasta=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2.all.maker.transcripts.fasta
#protein_fasta=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2.all.maker.proteins.fasta

#./get_subset_of_fastas.pl -l $MAKER2_standard_gene_list -f $transcript_fasta -o ./fruticosa_run2_STANDARD.all.maker.transcripts.fasta

#./get_subset_of_fastas.pl -l $MAKER2_standard_gene_list -f $protein_fasta -o ./fruticosa_run2_STANDARD.all.maker.proteins.fasta

#Next step - create the standard gene list gff file (don't uncomment this line!)

#./create_maker_standard_gff.pl --input_gff $gff3_MAKER2 --output_gff ./fruticosa_run2_STANDARD.all.gff --maker_standard_gene_list $MAKER2_standard_gene_list

