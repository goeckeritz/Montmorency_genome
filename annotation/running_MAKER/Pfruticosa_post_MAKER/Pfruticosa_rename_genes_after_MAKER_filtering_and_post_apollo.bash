#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J rename
#SBATCH --time 9:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/rename_genes_after_filtering%j


#yeah yeah, I get it -- not everyone is psycho enough to do manual annotation. But if you ARE, don't rename your genes until after you've created new gene models in apollo and taken out the old ones from your 
#filtered protein and transcript fastas, as well as your .gff. I used agat to do these steps: https://github.com/NBISweden/AGAT
#if you don't plan to do anything to your data post-filtering, you can ignore that and proceed to renaming the genes. 

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10
#module load BLAST+/2.9.0

cd /mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/

#Rename genes AFTER post-MAKER filtering in Bowman et al. 2017 and BEFORE functional annotation (at least before the iprscan steps)

maker_map_ids --prefix Pfrut_ --justify 6 ../fruticosa_postTEs_post_apollo_combined.gff3 > Pfruticosa_contig.all.map
# ^ that's pretty quick, maybe 5-10 minutes; do this first, then comment line 24, and uncomment lines 29-31
#the .map file is just a two-column file with old gene names and the new ones. 

#map_gff_ids Pfruticosa_contig.all.map ../fruticosa_postTEs_post_apollo_combined.gff3
#map_fasta_ids Pfruticosa_contig.all.map ../fruticosa_postTEs_post_apollo_combined_proteins.fasta
#map_fasta_ids Pfruticosa_contig.all.map ../fruticosa_postTEs_post_apollo_combined_transcripts.fasta

#note that these files get changed IN PLACE. Make a copy if you don't want to overwrite anything. 
