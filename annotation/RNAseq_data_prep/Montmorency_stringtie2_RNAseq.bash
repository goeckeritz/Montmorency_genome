#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J stringtie2
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/STAR/montAv5_p99_400k/StringTie/RNA_seq_stringtie_run1_montAv5_p99_400k_%j

module purge
module load GCC/8.3.0
module load SAMTools/1.9
module load StringTie/2.1.3

cd /mnt/scratch/goeckeri/RNA_seq/STAR/montAv5_p99_400k/StringTie/

#reads!
pooled_RNAseq_reads=/mnt/scratch/goeckeri/RNA_seq/STAR/montAv5_p99_400k/MNT_combined_sorted.bam

#command
stringtie -l RNAseq_STRG -m 200 -t -c 3 -f 0.05 -g 50 -p 32 -o mont_RNAseq_stringie2_run1_montAv5_p99_400k.gtf $pooled_RNAseq_reads


#note - each stringtie run should be checked with alignments in a genome browser to make sure adjacent genes are not bundled together. Sometimes you can only do so much... that's why we used defusion later on.

#The biggest problems I had were stringtie joining genes together, as the genes were very close together in the genome. Alter the parameters how you see fit for your genome!
#-l is a prefix for your reads for the output transcripts, is all...  
#-f min isoform fraction - fraction of the coverage an alternative transcript needs to be supported by to be considered 'real' default is 0.01 (SUPER low, it seems like. Sure enough, Jose changed this to 0.05, to make this a little more stringent (i.e., need more coverage to be deemed an alternative transcript; want to balance truth and noise)  
#-m minimum transcript length assembled. Coverage should be good for something that isn't noise -- I'm going to up this to 200. 
#-t disable trimming of predicted transcripts based on coverage. "By default StringTie adjusts the predicted transcript's start and/or stop coordinates based on sudden drops in coverage of the assembled transcript. Set this parameter to "False" to disable the trimming at the ends of the assembled transcripts (-t)"
#-c minimum reads per bp coverage to consider for a multi-exon transcript (default is 1), so 3 should be achievable in most cases. 
#-g maximum gap allowed between read mappings (of the same transcript model, I presume?). Jose specified 50; DEFAULT IS DIFFERENT WHEN YOU RUN stringtie --help (250) COMPARED TO WHAT GITHUB LISTS (50)
#-p number of threads to use.  
#-M fraction of bundle allowed to be covered by multi-hit reads (default is 1 according to --help command, which should always be checked, I guess). NA, we only have primary alignments in this RNA_seq dataset as well. Revisit this parameter if you'd like to have secondary alignments contribute to coverage (with a bit of penalty of course) 
#https://github.com/gpertea/stringtie
#very helpful explanations of the parameters:https://ugene.net/wiki/display/WDD31/Assemble+Transcripts+with+StringTie+Element
#-g flag seems to be a good one to focus on. If you have higher max gap between read mappings (250), looks like stringtie tended to combine close-together genes. And I guess if you made it more stringent (50 bp gap) it tended to not combine them as much(?).



# ONCE YOU HAVE THE GTF, you need to convert it to a .gff3 and replace some of the terms to make this file compatible with MAKER. I used cufflinks for the conversion.

#command for cufflinks (load it for your system first, however you do that):::

#gffread -E transcripts.gtf -o- > transcripts.gff3

#To be compatible with MAKER, the feature source must be est2genome, and the feature types must be expressed_sequence_match and match_part... DO:::

#sed -i 's/StringTie/est2genome/g' transcripts.gff3
#sed -i 's/transcript/expressed_sequence_match/g' transcripts.gff3
#sed -i 's/exon/match_part/g' transcripts.gff3

#hooray! your transcripts.gff3 file is now MAKER ready :)





