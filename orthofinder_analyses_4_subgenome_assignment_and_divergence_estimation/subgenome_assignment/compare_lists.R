#we've created 3 ortholog lists from pulling out phyDS direct sister relationships with BSV values greater or equal to 80%. 
#one for subA, subA__, and subB. ortholog lists contain 6797, 7036, and 10398 gene-gene relationships (lines in file), respectively.
#also have six syntelog lists:
#subA.tieton, subA__.tieton, subB.tieton, subA.fruticosa, subA__.fruticosa, subB.fruticosa. 
#If a syntelog pair is on our ortholog pair list, that area will be labeled as derived from that progenitor... 
#Have to attach coordinate info to every gene in Mont too. 

setwd("/Users/Goeckeritz/Desktop/Desktop - Charity’s MacBook Pro/cherry_stuff_Charity/Genome_project/manuscript/all_scripts/orthofinder_analyses_4_subgenome_assignment_and_divergence_estimation/subgenome_assignment/")
library(tidyverse)
library(dplyr)
library(ggplot2)

subA_tieton_syntelogs = read.table("subA_tieton_syntelogs.txt", header=FALSE)
subA___tieton_syntelogs = read.table("subA___tieton_syntelogs.txt", header=FALSE)
subB_tieton_syntelogs = read.table("subB_tieton_syntelogs.txt", header=FALSE)

subA_fruticosa_syntelogs = read.table("subA_fruticosa_syntelogs.txt", header=FALSE)
subA___fruticosa_syntelogs = read.table("subA___fruticosa_syntelogs.txt", header=FALSE)
subB_fruticosa_syntelogs = read.table("subB_fruticosa_syntelogs.txt", header=FALSE)

subA_orthologs_2_progenitors = read.table("subgenomeA_orthologs_for_syntelog_search.txt", header=FALSE)
subA___orthologs_2_progenitors = read.table("subgenomeA___orthologs_for_syntelog_search.txt", header=FALSE)
subB_orthologs_2_progenitors = read.table("subgenomeB_orthologs_for_syntelog_search.txt", header=FALSE)

gene_locations = read.table("scaffolded_chr_start_end_gene.txt", header = TRUE) #made this file from the .gff file for the genome

#what pairs of orthologs are also on each syntelogs list?

subA_sweet_cherry_assignments = merge(subA_tieton_syntelogs,subA_orthologs_2_progenitors) #75 / 81 sweet cherry ortholog pairs were syntelogs, so that's neat
subA_fruticosa_assignments = merge(subA_fruticosa_syntelogs, subA_orthologs_2_progenitors)
subA_progenitor_syntelogs = rbind(subA_sweet_cherry_assignments, subA_fruticosa_assignments)
#add a header to this file (honestly prolly shoulda done that in the first place, lol)
colnames(subA_progenitor_syntelogs) = c("gene", "gene_progenitor")
#merge by location information... 
subA_progenitor_locations = merge(subA_progenitor_syntelogs, gene_locations, by="gene")
head(subA_progenitor_locations)
subA = add_column(subA_progenitor_locations, progenitor = "NA" )
head(subA)

subA$progenitor <- ifelse(grepl("Pfrut_.*", subA$gene_progenitor), "fruticosa", "sweet_cherry")
subA$chr = as.factor(subA$chr)
subA_chr_list <- split(subA, subA$chr)
head(subA_chr_list$Pcer_chr1A)


#subA__
subA___sweet_cherry_assignments = merge(subA___tieton_syntelogs,subA___orthologs_2_progenitors) #75 / 81 ortholog pairs were syntelogs, so that's neat
subA___fruticosa_assignments = merge(subA___fruticosa_syntelogs, subA___orthologs_2_progenitors)
subA___progenitor_syntelogs = rbind(subA___sweet_cherry_assignments, subA___fruticosa_assignments)
#add a header to this file (honestly prolly shoulda done that in the first place, lol)
colnames(subA___progenitor_syntelogs) = c("gene", "gene_progenitor")
#merge by location information... 
subA___progenitor_locations = merge(subA___progenitor_syntelogs, gene_locations, by="gene")
head(subA___progenitor_locations)
subA__ = add_column(subA___progenitor_locations, progenitor = "NA" )
head(subA__)

subA__$progenitor <- ifelse(grepl("Pfrut_.*", subA__$gene_progenitor), "fruticosa", "sweet_cherry")
subA__$chr = as.factor(subA__$chr)
subA___chr_list <- split(subA__, subA__$chr)
head(subA___chr_list$Pcer_chr1A__)


#subB
subB_sweet_cherry_assignments = merge(subB_tieton_syntelogs,subB_orthologs_2_progenitors) 
subB_fruticosa_assignments = merge(subB_fruticosa_syntelogs, subB_orthologs_2_progenitors)
subB_progenitor_syntelogs = rbind(subB_sweet_cherry_assignments, subB_fruticosa_assignments)
#add a header to this file (honestly prolly shoulda done that in the first place, lol)
colnames(subB_progenitor_syntelogs) = c("gene", "gene_progenitor")
#merge by location information... 
subB_progenitor_locations = merge(subB_progenitor_syntelogs, gene_locations, by="gene")
head(subB_progenitor_locations)
subB = add_column(subB_progenitor_locations, progenitor = "NA" )
head(subB)

subB$progenitor <- ifelse(grepl("Pfrut_.*", subB$gene_progenitor), "fruticosa", "sweet_cherry")
subB$chr = as.factor(subB$chr)
subB_chr_list <- split(subB, subB$chr)
head(subB_chr_list$Pcer_chr1B)

#subgenome_syntelog_assignments = rbind(subA_progenitor_locations, subA___progenitor_locations, subB_progenitor_locations)
#write.csv(subgenome_syntelog_assignments, file="subgenome_syntelog_pairs.csv")

#let's try to use chromomap to visualize progenitor assignments. 
library(chromoMap)

subA_chrom = read.table("chromoMap_chromosome_file_subA.csv", sep=',', header=FALSE)
subA___chrom = read.table("chromoMap_chromosome_file_subA__.csv", sep=',', header=FALSE)
subB_chrom = read.table("chromoMap_chromosome_file_subB.csv", sep=',', header=FALSE)

annotation_subA = subA[, c("gene", "chr", "start", "end", "progenitor")]
annotation_subA__ = subA__[, c("gene", "chr", "start", "end", "progenitor")]
annotation_subB = subB[, c("gene", "chr", "start", "end", "progenitor")]


names(annotation_subA) = c("V1", "V2", "V3", "V4", "V5")
names(annotation_subA__) = c("V1", "V2", "V3", "V4", "V5")
names(annotation_subB) = c("V1", "V2", "V3", "V4", "V5")
head(subA_chrom)
head(annotation_subA)

chromoMap(list(subA_chrom,subA___chrom,subB_chrom),list(annotation_subA,annotation_subA__,annotation_subB),
          ploidy = 3,
          segment_annotation = T,
          n_win.factor = 4,
          win.summary.display = T,
          data_based_color_map = T, 
          data_type = "categorical",
          data_colors = list(c("paleturquoise2", "firebrick")),
          canvas_width = 3000,
          canvas_height = 3000,
          chr_width = 20,
          chr_length = 1,
          ch_gap = 15,
          text_font_size = 20,
          chr_text = F,
          interactivity = F)


#chr lengths:
#chr1A = 52663631
#chr1A__ = 51731447
#chr1B = 49141157	
#chr2A = 36246718
#chr2A__ = 36279249	
#chr2B = 36401203	
#chr3A = 29735487
#chr3A__ = 29577266
#chr3B = 28668097
#chr4A = 31254986	
#chr4A__ = 31557885
#chr4B = 26741905
#chr5A = 25936500	
#chr5A__ = 24865297	
#chr5B = 21076577	
#chr6A = 35368024	
#chr6A__ = 34923230	
#chr6B = 34495356
#chr7A = 28096969	
#chr7A__ = 26361588
#chr7B = 28491839	
#chr8A = 23458432
#chr8A__ = 23256865	
#chr8B = 25484195

#time plot by chr :)
#subA_1 = ggplot(subA_chr_list$Pcer_chr1A,aes(x=start,y=1)) +
  #geom_point(aes(color=progenitor), size=1)+
  #ggtitle("Subgenome A Chr1") +
  #xlab("Length (bp)") +
  #xlim(1,chr1A) +
  #ylab("")+
  #scale_color_manual(values=c("darkturquoise", "deeppink3"), labels = c("fruticosa", "avium"), name = "Progenitor") +
  #theme_minimal()

#subA_1
