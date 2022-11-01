####formatting some of the orthofinder output. 
#I want to filter for orthogroups (there are 31891 orthogroups that were identified between apple, peach, cherry, ground cherry, and sour cherry (subA, subA__, subB) -- no unanchored!
#that includes all '7' of the species (note there are really 7 species, sour cherry was just split in 3, omitted unanchored). These will later be used to infer subgenome histories..... I hope -- and, species trees according to Pat's methods in the mimulus and or strawberry papers.  
#We'll use the gene counts file to find out which orthogroups fitting that criteria. unanchored is highly fragmented -- so it is excluded to obtain more orthogroups incl. all 7 'species', and more 1:1 groups. These will be used to find subgenome origin in the more complete part of the genome and get a better estimate of these species' divergence.  
#orthogroups including all species == 12051
#single copy orthogroups == 336

setwd("/Users/Goeckeritz/Desktop/Desktop - Charity’s MacBook Pro/cherry_stuff_Charity/Genome_project/orthofinder/montAv5_p99_400k/scaffolded_genome/")
library(tidyverse)

og_total = read.csv('Orthogroups.GeneCount.tsv', sep='\t', header=TRUE)
head(og_total)
x = vector("numeric", length=255128) # species+1 x all orthogroups
additions = data.frame(matrix(ncol = 8, x))
additional_columns = c("apple_y_n", "fruticosa_y_n", "peach_y_n", "subA___y_n", "subA_y_n", "subB_y_n", "sweetcherry_y_n", "unique_sp")
colnames(additions) = additional_columns
og_total = bind_cols(og_total, additions)

head(og_total)


#these loops will put a 1 in the species_y_n column if there are 1 or more orthologs present in the orthogroup. Otherwise a 0 will be there.
for (i in 1:nrow(og_total)){
  if (og_total$apple_prot[i]>=1)
    og_total$apple_y_n[i] <- 1
else {
  og_total$apple_y_n[i] <- 0
}}
head(og_total)
summary(og_total)

for (i in 1:nrow(og_total)){
  if (og_total$fruticosa_prot[i]>=1)
    og_total$fruticosa_y_n[i] <- 1
  else {
    og_total$fruticosa_y_n[i] <- 0
  }}

for (i in 1:nrow(og_total)){
  if (og_total$peach_prot[i]>=1)
    og_total$peach_y_n[i] <- 1
  else {
    og_total$peach_y_n[i] <- 0
  }}

for (i in 1:nrow(og_total)){
  if (og_total$subA___prot[i]>=1)
    og_total$subA___y_n[i] <- 1
  else {
    og_total$subA___y_n[i] <- 0
  }}

for (i in 1:nrow(og_total)){
  if (og_total$subA_prot[i]>=1)
    og_total$subA_y_n[i] <- 1
  else {
    og_total$subA_y_n[i] <- 0
  }}

for (i in 1:nrow(og_total)){
  if (og_total$subB_prot[i]>=1)
    og_total$subB_y_n[i] <- 1
  else {
    og_total$subB_y_n[i] <- 0
  }}

for (i in 1:nrow(og_total)){
  if (og_total$sweet_cherry_prot[i]>=1)
    og_total$sweetcherry_y_n[i] <- 1
  else {
    og_total$sweetcherry_y_n[i] <- 0
  }}

head(og_total)

#this code then sums up the species_y_n values 
og_total$unique_sp <- rowSums(og_total[ ,10:16])
head(og_total)
summary(og_total)

#now, if we want to work with orthogroups only containing all '7' of the species, we can drop all rows where unique_sp < 7.
og_7sp <- og_total %>%
  dplyr::filter(unique_sp >= 7)

head(og_7sp)

#clean up these datasets and drop columns that are no longer needed. Then write them to a new .tsv for downstream analyses. Preliminary filtering complete!
og_7sp_clean <- og_7sp[c(1:9)]

#install.packages("vroom")
library(vroom)

write_tsv(og_7sp_clean, "orthogroups_7sp.tsv")



#some post steps to get these orthogroup_MSAs in their own directory:

#to get the first column:

#awk '{print $1}' orthogroups_7sp.tsv > orthogroups_7sp_sequences.txt

##these files will be the same initially but then we are going to use sed to turn this column into a list of these files specifically. 
##Use nano to go into the files and delete the headers. the sed below will add .fa to every line, editing the file in place. 

#sed -i 's/$/.fa/' orthogroups_7sp_sequences.txt
##the MSA and sequences files actually have the same file names so you really only need one of the lists above. 

##copy all needed files to new directories -- make sure the new folder already exists, and navigate to the directory where all the files are that you want to copy:
#cp `cat ../orthogroups_7sp_sequences.txt` ../7sp_Orthogroup_sequences/

##When we have all of our alignments.. it's time to grab the needed sequences from the species' cds files. 
##copy them to cds_seqs/ Then, make a list of all the sequences in the MSAs by doing:

# grep -Rh '^>' ./ > 7sps_MSAs_sequence_list.txt
## output is a bit messy, but you can clean it up with sed. 
# see 