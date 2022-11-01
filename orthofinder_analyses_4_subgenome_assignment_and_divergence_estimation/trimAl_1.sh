#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J 1trimAl
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/trimAl/1trimAl_j%

ml GCCcore/9.3.0
ml trimAl/1.4.1

#your indv_orthogroup_cds_MSAs/ directory should have a subset of your cds_MSAs.fa in it, and you might have several of these folders. 
cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/trimAl/orthogroup_gene_lists/orthogroup_gene_lists_renamed/indv_orthogroup_cds_MSAs/

#before beginning, in the trimAl/ directory, create directories trimmed1/ trimmed2/ etc., for however many indv_orthogroup_cds_MSAs folders you have. 

for i in $(ls OG*cds_MSAs.fa); do
trimal -in $i -out /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/trimAl/trimmed1/$(echo $i | sed 's/cds_MSAs/_trimmed_cds_MSAs/g') -automated1
done

#run any number of these loops depending on how many indv_orthogroup_cds_MSAs folders you have. cd to the appropriate indv_orthogroup_cds_MSAs folder and put the output in the 
#appropriate trimmed#/ folder. 

#for trimAl docs: http://trimal.cgenomics.org/

#When you get your trimmed alignments, inspect them against the original alignments to see that the super noisy parts of alignments (often at the flanking ends of each MSA) are removed.
#I viewed alignments with: https://www.ebi.ac.uk/Tools/msa/mview/

#some relevant notes... 
#-automated1 			  Use a heuristic selection of the automatic method based on similarity statistics. (see User Guide). According to the paper, this method has been optimized for Max Likelihood tree construction -- which is what we'll be doin!
#-gt -gapthreshold <n>    1 - (fraction of sequences with a gap allowed).
#-seqoverlap              Minimum percentage of "good positions" that a sequence must have in order to be conserved. (see User Guide).

#DO NOT use the keepheader option -- it will mess with the headers of your sequences -- I discovered that a single copy orthogroup dropped a fruticosa gene, but kept the header and put it on sweet cherry. Like, what the hell??

#I compared a couple diff trimAl parameters and -automated1 worked swell. I'll stick with that - 6/23/22

#next we'll build some phylogenetic trees, baby! See gene_trees_subgenome_pipeline#.sh




