#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J RAxML-all-in-one
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10g
#SBATCH -o /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/polyploidy_event_est/RAxML_top6_%j

cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/polyploidy_event_est/

ml purge
ml icc/2019.1.144-GCC-8.2.0-2.31.1  impi/2018.4.274
ml RAxML-NG/1.0.0

raxml-ng --all --threads 12 --msa combined_topology6_species_MSAs.fa --model GTR+G --tree pars{10} --bs-trees 500 --outgroup M_x_domestica

#see notes in the gene_trees_subgenome_pipeline1_READ_ME.sh script to know what combined_topology6_species_MSAs.fa is and how to generate it!
#Next, you take the *.raxml.bootstraps and calculate node ages for each bootstrap. 
#See 