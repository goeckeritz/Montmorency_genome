#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J 1get_individual_cds_fastas
#SBATCH --time 36:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/trimAl/1get_individual_cds_fastas_%j

#first things first, you need to make an individual gene list for each orthogroup. 
#FYI, the order in which the get_subset_of_fastas.pl script is given genes in a list
#is the order it will put the sequences in your individual orthogroup cds MSAs (which is what you want, and it might be good to check this happens just in case.)

#create a trimAl/ directory somewhere that makes sense to you. 
#create a orthogroup_gene_lists/ directory inside that...
#an orthogroup_gene_lists_renamed/ directory inside that...
#and 1 or more directories (001, 002, etc) inside that. 

#To make the orthogroup gene lists, go to the directory with all of your MSAs and run this loop... :
#   for i in $(ls -1 *.fa | sed 's/.fa//' ); do
#   grep '^>' $i.fa > path/to/orthogroup_gene_lists/$(echo $i)_gene_list.txt
#   done

#then go to orthogroup_gene_lists/ and run this to get rid of the > at the beginning of each gene name... :
#   for i in $(ls -1 OG*_gene_list.txt); do
#   sed 's/^>//' $i > /orthogroup_gene_lists_renamed/$(echo $i)
#   done

#I realize those two loops probably could have been done together and in only one directory but... meh. You get more efficient as you go along, right? 
# count how many orthogroup gene lists you have with:

#   ls -1 *_gene_list.txt | wc -l

#split these gene lists ~equally in your 00# folders. So if I had 1000 gene lists and I made five 00# folders, I'd do:

#	mv `ls -1 *_gene_list.txt | head -n 200` 001/
#	mv `ls -1 *_gene_list.txt | head -n 200` 002/

# and so on until all the gene lists had been divided up. 


#After you have an individual gene list for every orthogroup and they are dispersed in subfolders, you're ready to use the concatenated cds MSAs.fa file output from pal2nal to create the individual orthogroup cds MSAs
#before you begin, create several more subfolders in the /orthogroup_gene_lists_renamed/ directory of the format indv_orthogroup_cds_MSAs/, indv_orthogroup_cds_MSAs2/, indv_orthogroup_cds_MSAs3/, etc
#This is where our output will go. Have your get_subset_of_fastas.pl in the orthogroup_gene_lists_renamed/ folder as well. 

ml icc/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
ml MAKER/2.31.10

cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/trimAl/orthogroup_gene_lists/orthogroup_gene_lists_renamed/001/

for i in $(ls OG*_gene_list.txt); do
../get_subset_of_fastas.pl -l $i -f /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/pal2nal/concatenated_7sp_cds_MSAs.fa -o ../indv_orthogroup_cds_MSAs/$(echo $i | sed 's/_gene_list.txt/cds_MSAs.fa/g')
done

# -f should be path/to/your/concatenated/cds/MSAs/output/from/pal2nal/

#NEXT STEPS:
#parallelize your trimAl jobs - i.e., trim the ugly parts of your cds MSAs -- these greatly skew phylogenetic analyses. See
#   trimAl_1.sh


# ended up separating the 12,050 orthogroup lists into 8 different directories -- if I hadn't, this job probably would have taken 3 days!! hopefully it only takes 1 now. The spaces at the end of the cherry gene names are gone now. killed those. That was causing me issues. 