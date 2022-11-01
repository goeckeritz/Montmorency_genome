#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J phyDS
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/subgenomes/phyDS_1_%j


ml purge
ml GCCcore/8.3.0
ml BioPerl/1.7.2

cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/subgenomes/

#you can modify this script at the phyDS.pl command if you want to know when orthologs ended up with apple, peach, etc besides just fruticosa and sweet cherry. But when sister to only one taxa other than itself, montmorency orthologs predominantly group with fruticosa and sweet cherry.

#first, move all of your trees equally between however many directories you want. I did 20, so it was sort of like I was manually multi-threading phyDS with 20 threads. 
#create paralog lists for every individual orthogroup's tree in a directory called paralog_lists/... the columns are doubled to ensure even paralog searches. I tried Michael's estimate_paralogs_from_trees.pl but it was not giving me the output I expected... So I did this little hack to make my own paralog lists. 
#I verified phyDS was extracting the relationships I was expecting by looking at the .*Subgenome_Reslts.txt and the tree in question in a tree viewer for something like 10-20 trees or so.
#I noted that some homoeologs get repeated in the final column of .*Subgenomes_Results.txt, but this only appeared to occur when a homoeolog was sister to another Montmorency homoeolog. We are not interested in these lines anyway as they do not give us subgenome information :/ 

#Make the paralog lists (these are the genes we will search for in trees to see what they are sister to)
 for i in $(ls -1 trees1/ | sed 's/.raxml.support//g'); do
grep -oE 'subA_.*|subB_.*|subA__.*' /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/trimAl/orthogroup_gene_lists/$(echo $i).txt | sed 's/\t\t*/\n/g' | awk '{print $1,$1}' > paralog_lists/$(echo $i)_double_gene_list
done
#NOTE: reversing the order of the genes in the second column of each list didn't change the results. we're going to move on even though some homoeologs get repeated in their final column, as if they are sister to themselves and another mont homoeolog. We are not interested in these lines anyway. 

#mv your *.raxml.support trees to the directory 'trees' <-- then, move your tree files equally into however many folders (trees1, trees2, trees3, etc.). PhyDS takes a while so this is how I multi-threaded it.
#e.g., if you had 1000 trees and were gonna make 20 folders, put 50 *.raxml.support files in each folder. 
#create the same number of folders for phyds output - e.g., phyDS1, phyDS2, phyDS3, etc.
 
cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/subgenomes/phyDS1/

for i in $(ls -1 ../trees1/ | sed 's/.raxml.support//g'); do
perl ../phyDS.pl -p /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/subgenomes/paralog_lists/$(echo $i)_double_gene_list --trees /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/subgenomes/trees1/ --ignore peach,apple --name $i --bootstrap 80
done

#We're going to make a tab delimited list of when orthologs are directly sister to sweet cherry or fruticosa orthologs by extracting the columns we need. We also delete the headers for each file, then squish the results together to make the data more tidy.
for i in $(ls -1 *_Subgenome_Results.txt | sed 's/_Subgenome_Results.txt//g'); do
sed '1d' $(echo $i)_Subgenome_Results.txt | awk '{print $1,$4,$8}' > $(echo $i)_no_headers
done

#combine and drop the lines with commas, cuz these indicate a phylogenetic relationship where our ortholog in question is not cleanly and directly sister to an ortholog from sweet cherry or fruticosa. I.e., If there are commas, it indicates the montmorency_gene is not directly sister to only one representative progenitor gene.
cat *_no_headers | awk '{print $2,$3}' | awk '$2~/,/ {next} {print}' > combined_subgenome_results_for_identifying_syntelogs1.txt

#concatenate all of the .txt files in the separate directories for the complete Mont homoeolog to representative progenitor list. 
cat combined_subgenome_results_for_identifying_syntelogs*.txt > combined_subgenome_results_for_identifying_syntelogs_ALL.txt

#I had ~100 other relationships in the combined results that were a direct sister relationship of a mont gene to something other than fruticosa and sweet cherry (i.e., apple or peach)
#I filtered those out by taking only lines with fruticosa or sweet cherry genes on them. 
grep -e 'sweet' -e 'fruticosa' combined_subgenome_results_for_identifying_syntelogs_ALL.txt > combined_subgenome_results_for_identifying_syntelogs_sweet_and_fruticosa.txt
#There were 24347 relationships in ALL.txt, 24231 in _sweet_and_fruticosa.txt ... meaning 99.5% of direct sister relationships of a mont ortholog to any other species was to sweet cherry or fruticosa. 

#something went wrong if any mont ortholog is repeated in the final file. Do:
#awk '{print $1}' file.txt | awk 'visited[$0]++' combined_subgenome_results_for_identifying_syntelogs_sweet_and_fruticosa
#you can check the second column too by replacing $1 with $2, but... don't think it's really necessary.
#In either case, you should get NO OUTPUT.

#next, I split the output into results per subgenome:
grep 'subA_prot_' combined_subgenome_results_for_identifying_syntelogs_sweet_and_fruticosa > subgenomeA_orthologs_for_syntelog_search.txt
grep 'subA___prot_' combined_subgenome_results_for_identifying_syntelogs_sweet_and_fruticosa > subgenomeA___orthologs_for_syntelog_search.txt
grep 'subB_prot_' combined_subgenome_results_for_identifying_syntelogs_sweet_and_fruticosa > subgenomeB_orthologs_for_syntelog_search.txt

#Then, I changed the gene names in each file back to what they originally were by doing this for each of the 3 subgenome ortholog results files:
sed -i 's/sub*_prot_//' subgenome*_orthologs_for_syntelog_search.txt
sed -i 's/fruticosa_prot_//' subgenome*_orthologs_for_syntelog_search.txt
sed -i 's/sweet_cherry_prot//' subgenome*_orthologs_for_syntelog_search.txt

#Now we have to ask - which of these ortholog pairs are also syntelogs?
#Get syntelog list from MCscan where each subgenome is compared to each progenitor (3 x 2 = 6 syntelog lists) separately. You'll need to split
#your .gff and .cds.fasta files into separate files per subgenome. See the MCscan script next. 

 





#A problemo I had to deal with:
#hard to know why this happens, but as it stands now, phyds will have the target paralog (a subA, subA__ or subB gene) printed out as being sister to itself sometimes. This seems to be happening only when the target
#paralog is sister to another mont homoeolog (subA, subA__, or subB). technically we wouldn't want to use these lines anyway, but.. like, what the hell. 
#I've manually checked dozens of trees and the output for genes sister to fruticosa and sweet cherry is correct based on bootstrap values. 


