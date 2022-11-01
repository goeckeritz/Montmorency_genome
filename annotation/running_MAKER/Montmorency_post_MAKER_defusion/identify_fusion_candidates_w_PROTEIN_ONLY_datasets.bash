#!/bin/sh

#These commands were written by Kevin Childs
#go to where your regular standard dataset is, cuz we are going to find which predictions in there might be fusions.
cd /data/run/goeckeri/montAv5_p99_400k_annotation/ 

#get the genes in your regular dataset
perl -e  'while (my $line = <>){ my @elems = split "\t", $line; if ($elems[1] eq 'maker' && ($elems[2] eq 'gene')) { print $line;  } }' Pcerasus_montAv5_p99_400k_STANDARD.all.sorted.clean.gff  >  Pcerasus_montAv5_p99_400k_STANDARD.all.sorted.clean.genes_only.gff


#get the genes in your PROTEIN ONLY standard dataset
perl -e  'while (my $line = <>){ my @elems = split "\t", $line; if ($elems[1] eq 'maker' && ($elems[2] eq 'gene')) { print $line;  } }' Pcerasus_montAv5_p99_400k_STANDARD_PROTEIN_ONLY.all.clean.sorted.gff > Pcerasus_montAv5_p99_400k_STANDARD_PROTEIN_ONLY.all.clean.sorted.genes_only.gff

module load BEDtools/2.23.0

bedtools intersect -c -a /data/run/goeckeri/montAv5_p99_400k_annotation/Pcerasus_montAv5_p99_400k_STANDARD.all.sorted.clean.genes_only.gff -b /data/run/goeckeri/montAv5_p99_400k_annotation/Pcerasus_montAv5_p99_400k_STANDARD_PROTEIN_ONLY.all.clean.sorted.genes_only.gff > /data/run/goeckeri/montAv5_p99_400k_annotation/Pcerasus_montAv5_p99_400k_STANDARD_overlapping_with_protein_only_predictions.gff

#The file “Pcerasus_montAv5_p99_400k_STANDARD_overlapping_with_protein_only_predictions.gff” is not a typical gff file.  
#It has a number at the end of each line that indicates the number of predictions from the STANDARD_PROTEIN_ONLY file that overlapped with the predictions from the STANDARD file.  
#You should be able to sort on the last number on each line.  Ignore those with 0’s or 1’s.  Let’s see how many have 2 or more overlaps.

#then, grab the lines (genes) from this overlap file that have 2 or more protein overlaps according to the PROTEIN ONLY FILE:
awk -F'\t' '$10 > 1' Pcerasus_montAv5_p99_400k_STANDARD_overlapping_with_protein_only_predictions.gff > fusion_candidates_to_check.gff

#Note - we only checked and potentially defused candidates that were on the main 25 scaffolds (no unanchored genes were checked)
#so we filtered that candidate list by doing:
#grep -v 'unanchored' fusion_candidates_to_check.gff > scaffolded_fusion_candidates_to_check
#we had 7000+ to check and it took like a month it seemed like XD

#load RNAseq .bam files, protein evidence, and nanopore evidence and check each one of these..
#As we checked the candidates and added them to the .brk file for defusion step2, we also 
#created a list of genes that would need to be removed prior to reannotation to prevent 
#a gene being annotated twice. 