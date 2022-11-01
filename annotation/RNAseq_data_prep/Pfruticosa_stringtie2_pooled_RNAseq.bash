#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J stringtie2
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR/StringTie/RNA_seq_stringtie_run1_fruticosa_%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load minimap2/2.15.Py3
module load SAMTools/1.9
module load StringTie/2.1.2

cd /mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR/StringTie/

#reads! #noFilter XD
pooled_RNAseq_reads=/mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR/frut_combined_sorted.bam

#command
stringtie -l RNAseq_STRG -m 200 -t -c 3 -f 0.05 -g 50 -p 32 -o frut_RNAseq_stringie2_run1.gtf $pooled_RNAseq_reads


#see Montmorency equivalent of this file for notes, incl. how to process the .gtf file so it is 'MAKER ready'


#notes - each stringtie run should be checked with protein alignments to make sure adjacent genes are not bundled together. 
#The biggest problems appear to be stringtie joining genes together... parameters related to this feature could be... 
#-l is a prefix for your reads for the output transcripts, is all...  
#-f min isoform fraction - fraction of the coverage an alternative transcript needs to be supported by to be considered 'real' default is 0.01 (SUPER low, it seems like. Sure enough, Jose changed this to 0.05, to make this a little more stringent (i.e., need more coverage to be deemed an alternative transcript; want to balance truth and noise)  
#-m minimum transcript length assembled. Coverage should be good for something that isn't noise -- I'm going to up this to 200. 
#-t disable trimming of predicted transcripts based on coverage. Jose just did -t so I guess he just.. activated the default? "By default StringTie adjusts the predicted transcript's start and/or stop coordinates based on sudden drops in coverage of the assembled transcript. Set this parameter to "False" to disable the trimming at the ends of the assembled transcripts (-t)"
#I'll keep an eye on the results of this transcript assembly, I guess... I just don't know what stringtie will do to decide when a 'drop in coverage' has happened if only 1-2 reads support a transcript model >.<
# so turn on? (or actually put 'FALSE', I think) -t flag if you don't want StringTie trying to predict start/stop coordinates based on coverage >.< This is probably something that is used more often with short reads, since it has oober amounts of coverage. I'm definitely not expecting much coverage with the nanopore reads.  
#-c minimum reads per bp coverage to consider for a multi-exon transcript (default is 1), so 3 should be achievable in most cases. 
#-g maximum gap allowed between read mappings (of the same transcript model, I presume?). Jose specified 50; DEFAULT IS DIFFERENT WHEN YOU RUN stringtie --help (250) COMPARED TO WHAT GITHUB LISTS (50)
#-p number of threads to use.  
#-M fraction of bundle allowed to be covered by multi-hit reads (default is 1 according to --help command, which should always be checked, I guess). NA, we only have primary alignments in this RNA_seq dataset as well. Revisit this parameter if you'd like to have secondary alignments contribute to coverage (with a bit of penalty of course) 
#https://github.com/gpertea/stringtie
#very helpful explanations of the parameters:https://ugene.net/wiki/display/WDD31/Assemble+Transcripts+with+StringTie+Element
#-g flag seemed to be the flag Jose focused on. If you have higher max gap between read mappings (250), looks like stringtie tended to combine close-together genes. And I guess if you made it more stringent (50 bp gap) it tended to not combine them as much(?). This will be very important for something like the DAM cluster on Chr1. 
#FYI, stringtie merge will be helpful if you need to merge multiple gtf files. I may need this for the demultiplexed fastqs. - correction 2/8/21; Kevin said just pool the reads, no need for demultiplexing for gene finding. Pay attention to that later if you're interested in tissue-specific expression. 
#Is there a con to decreasing g? Can we go so low that it becomes detrimental to transcript assembly? I'll go with 50 and see what the transcripts look like, I suppose. 

