#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J full_genome_orthofinder
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/gs21/scratch/goeckeri/orthofinder_montAv5/scaffolded_genome_orthofinder_%jar

module purge
module load GCC/8.3.0  OpenMPI/3.1.4
module load OrthoFinder/2.5.4-Python-3.7.4
module load FastTree/2.1.11

cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5/Genomes/

orthofinder -t 24 -a 5 -M msa -A mafft -z -oa -p /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/temp/ -n orthofinder_scaffolded -f proteins/

#subgenomes A, A', and B were treated as separate 'species' in this analysis. So each had its own proteins.fa file in the proteins/  directory. 
#I used the get_subset_of_fastas.pl a bunch to get separate files for each species. 

#when making the gene list to extract with get_subset_of_fastas.pl:
#grep '^>prefix.*\-R[A,B]\s'
#then use sed to remove the > and \s characters.
#sed -i 's/>//g' file.txt
#sed -i 's/\s//g' file.txt


#After getting the output, I only wanted to move forward with the orthogroups that had all species in them.
#I used some output files and an R script to get a list of what these groups were. See: filtering_4#_species_montAv5_scaffolded.R
