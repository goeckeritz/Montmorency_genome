#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J blast_TEs_post_MAKER
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/Tpases_filtering_blastp_%j

#these commands are from Bowman et al. 2017 (A modified GC....) - perl scripts are from Childs Lab GitHub repository. 

#note - you need to make a blast db first and have it in the same directory as the Tpases#####.fasta. see commented line. 

module purge
module load BLAST+/2.9.0

Tpases_maker_wiki=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/Tpases020812.fasta
STANDARD_proteins=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2_STANDARD.all.maker.proteins.fasta

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/

#makeblastdb -in Tpases020812.fasta -input_type fasta -dbtype prot -out Tpases020812.fasta

blastp -db $Tpases_maker_wiki -query $STANDARD_proteins -out STANDARD_proteins_to_Tpases -evalue 0.0000000001 -outfmt 6 -num_threads 20

#one of several steps to find Tpases in your protein predictions
#you can find the Tpases fasta from the maker wiki page: http://weatherby.genetics.utah.edu/MAKER/wiki/index.php/Repeat_Library_Construction-Advanced
#scroll towards the bottom - click 'here' where it says: "All transposase protein database is available here" 
#The input proteins fasta has already been filtered to only include predictions with known pfam domains


