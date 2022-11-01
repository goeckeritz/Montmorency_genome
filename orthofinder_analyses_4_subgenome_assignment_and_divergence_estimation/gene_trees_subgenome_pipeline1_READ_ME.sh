#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J gene_trees1
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/subgenomes/gene_trees_001_%j

ml icc/2019.1.144-GCC-8.2.0-2.31.1  impi/2018.4.274
ml RAxML-NG/1.0.0

#create a RAxML directory, a subgenomes directory in that, and subfolders 001 - 00# inside that -- however many trimmed#/ directories you have. These subfolders are where your RAxML output will go. 
#you'll run this loop for however many trimmed#/ folders you have with trimmed_cds_MSAs.fa in them.

cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/subgenomes/001

for i in $(ls -1 /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/trimAl/trimmed1/*trimmed_cds_MSAs.fa); do
raxml-ng --all --msa $i --threads 16 --model GTR+G --tree pars{10} --bs-trees 500 --outgroup $(grep -oh 'apple_prot_Mdg.*' $i) --prefix ./$(echo $i | sed 's/\/mnt\/gs21\/scratch\/goeckeri\/orthofinder_montAv5_scaffolded\/Genomes\/trimAl\/trimmed1\///g' | sed 's/_trimmed_cds_MSAs.fa//g')
done

#this part of the command:
#     sed 's/\/mnt\/gs21\/scratch\/goeckeri\/orthofinder_montAv5_scaffolded\/Genomes\/trimAl\/trimmed1\///g'
#gets rid of the path name. So you'll need to adjust it for whatever your path is!

#this:
# --outgroup $(grep -oh 'apple_prot_Mdg.*' $i)
# ensures an apple protein(s) will be the outgroup(s)

#WARNING: if you don't give RAxML ample threads in your job submission, it might crash. Always ask for more than you end up allowing RAxML to use.

#see https://github.com/amkozlov/raxml-ng for more info on parameters. 

#At this point, the divergence estimation and subgenome analyses go in different directions. 

#once you have all your gene trees, you can extract the relationships giving you subgenome information with phyDS - see phyDS_loop*.sh

#For the node age estimates (divergence estimation), we first had to do some manual labor >.<'
#Incomplete lineage sorting will often lead to a species tree =/= gene trees. And Prunus species hybridize like MAD. Also, homoeologous recombination of subgenomes may affect gene trees.
#And typically, when you estimate node ages from gene trees, you don't want to mix gene trees of different topologies because it introduces noise and inflates your node age estimates. 
#So, I examined every one of the single-copy gene topologies prior to deciding how to date divergence estimates of subgenome from representative progenitor. 
#I discovered more than 20+ gene topologies. Yikes. Our ultimate goal was to find out what progenitor our subgenomes were most likely derived from... and we had 3 subgenomes and 2 progenitors. You can see the issue when we are dealing with single-copy orthologs. 
#Thus I anticipated I'd need to estimate node ages of more than one topology. When looking through the topologies of our 336 single-copy orthogroup gene trees, 
#subA and subA' would often switch off pairing with fruticosa. Interestingly, if fruticosa is an allotetraploid with 2 intact subgenomes, and subA and subA' are indeed derived from the different subgenomes from a fruticosa-like progenitor,
#this is what you would expect. Using single-copy orthologs in a known polyploid (fruticosa) automatically means you're working with a gene that likely had several copies but was collapsed during assembly (or maybe other copies had been missed during annotation).
#Either way, whether the collapsed gene comes from subgenome 1 or 2 in fruticosa should be random if both subgenomes are intact...
#And, in the most common topologies, ~50% of the time subgenome A paired with fruticosa, and in the other 50% -- subgenome A' paired with fruticosa. 
#The most common topologies had such relationships. Thus we inferred one topology probably contained mostly orthologs from subgenome 1 in fruticosa 
#whereas the other topology contained most orthologs from subgenome 2. 
#So we did our best -- and estimated node age estimates from these two topologies to get a sense of how long ago subA and fruticosa(sub1) diverged from their MRCA
#and how long ago subA' and fruticosa(sub2) diverged from their MRCA. 
#I'm documenting this only to say that you're going to have to look at your topologies... know something about the species and progenitors, and decide if you need to 
#estimate node ages for multiple topologies based on your questions and the limitations of your data.

#note that your orthofinder output has a folder for single copy orthogroups (Single_Copy_Orthologue_Sequences/), so you should know what gene trees' topologies to look at.

#once you figure out the most common topology(ies) that will answer your questions, take the orthogroup sequences matching a topology and concatenate them [in order] per species. 
#How I did this was I first made a list of the genes in each orthogroup per species in order of orthogroup. E.g., say we have 5 orthogroups matching a topology. My species gene lists would look something like:

#apple list:

#apple1
#apple2
#apple3
#apple4
#apple5

#peach list:

#peach1
#peach2
#peach3
#peach4
#peach5

#You can make these lists by going to Single_Copy_Orthologue_Sequences/ and doing something like this for each species:
#grep 'apple.*' ./OG* > apple_single_copy_genes.txt

#grep should search the same orthogroups in the same order, but never hurts to double check that. 

#The MSA for orthogroup 1 including 2 species (apple and peach) would look something like this:

# >apple1
# TCGATT--TTCA
# >peach1
# TCGATTCA--GA

#you then use get_subset_of_fastas.pl, your species gene list, and the concatenated cds MSAs from pal2nal to extract these sequences for each species. 
#So the beginning of your individual species MSAs for your single-copy orthogroups would then look like:

#	>apple1 
#	TCGATT--TTCA
#	>apple2
#	GATTCCCA--AT
#	...(all the way to 5 seqs)

#	>peach1
#	TCGATTCA--GA
#	>peach2
#	GAAAGCCATTAT
#	...(all the way to 5 seqs)

#Then, you should delete your current headers and fold the files.

#For each species' .fasta, do:

#	sed -i '/^>/d' species.fa
#	fold -w 80 species.fa > species_folded.fa

#this will delete the lines with headers, then take all the characters in your fasta and put 80 on each line - nice and tidy-like!

#then, go into each species_folded.fa and add a single header for the entire concatenated sequence. Example >M_x_domestica

#when each species has its own concatenated fasta, you concatenate the individual species fastas...
#With our example above, we'd end up with something like:

#	>M_x_domestica 
#	TCGATT--TTCA
#	GATTCCCA--AT
#	>P_persica
#	TCGATTCA--GA
#	GAAAGCCATTAT

#but you know, imagine more characters per line and more sequence. You use this file to make another tree in RAxML, and then you calculate age estimates from all bootstrap replicates to 
#get confidence intervals for your node ages. 








