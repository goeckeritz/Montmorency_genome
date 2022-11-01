#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J post_TE_filtering
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/post_TE_filtering_%j

#these commands are from Bowman et al. 2017 (A modified GC....) - perl scripts are from Childs Lab GitHub repository. 
#we run them again after we obtain the TE filtered gene list. The idea is to grab the subsets of the gff, protein fasta, and transcripts fasta matching the TE filtered gene list. 

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

STANDARD_gff=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/post_defusion_step4/fruticosa_run2.all.std.gff
TE_filtered_gene_list=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2_standard_gene_list_TE_filtered

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/

./create_maker_standard_gff.pl --input_gff $STANDARD_gff --output_gff ../fruticosa_run2.all.TE_filtered.gff --maker_standard_gene_list $TE_filtered_gene_list

#after you get the gff with no TE genes, get the fastas too... 

STANDARD_transcript_fasta=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/post_defusion_step4/fruticosa_run2.all.maker.transcripts.std.fa
STANDARD_protein_fasta=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/post_defusion_step4/fruticosa_run2.all.maker.proteins.std.fa

./get_subset_of_fastas.pl -l $TE_filtered_gene_list -f $STANDARD_transcript_fasta -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2.all.maker.transcripts.TE_filtered.fasta

./get_subset_of_fastas.pl -l $TE_filtered_gene_list -f $STANDARD_protein_fasta -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2.all.maker.proteins.TE_filtered.fasta
