#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J stringtie2_nanopore_run1
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/minimap2/montAv5_p99_400k/StringTie2/stringtie_run1_montAv5_p99_400k_%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load minimap2/2.15.Py3
module load SAMTools/1.9
module load StringTie/2.1.2

cd /mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/minimap2/montAv5_p99_400k/StringTie2/

#reads!
nanopore_reads=/mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/minimap2/montAv5_p99_400k/nanopore_filt150_pooled_montAv5_p99_400k_sorted.bam

#command
stringtie -L -l Pcera -m 150 -t -c 1 -f 0.05 -g 50 -p 32 -o mont_nanopore_stringtie2_run1_montAv5_p99_400k.gtf $nanopore_reads

#this takes your aligned cDNA reads and makes transcript models from them. Always check the results in a genome browser and then optimize if needed



#-f min isoform fraction - fraction of the coverage an alternative transcript 
## still weird that allowing for -N flag to be 5 makes for better mapping. But I'll see how this affects the transcriptome assembly. #-m minimum transcript length assembled. Jose restricts this to 300 bp. Everything else is treated as noise, I suppose? I did 150 cuz that was my nanopore filter... might get some noise with this but it's not like this will be the final file fed to MAKER. I'm gonna try to incorporate long read and short read data in Mikado before that, I think. 
#-t disable trimming of predicted transcripts based on coverage. Jose just did -t so I guess he just.. activated the default? "By default StringTie adjusts the predicted transcript's start and/or stop coordinates based on sudden drops in coverage of the assembled transcript. Set this parameter to "False" to disable the trimming at the ends of the assembled transcripts (-t)"
#so turn on -t flag if you don't want StringTie trying to predict start/stop coordinates based on coverage >.< This is probably something that is used more often with short reads, since it has oober amounts of coverage. I'm definitely not expecting much coverage with the nanopore reads.  
#-c minimum reads per bp coverage to consider for a multi-exon transcript (default is 1. Jose used 2.5). Since we have reeeeeal light coverage and other means of evidence, I'm going to go with 1. If this is a problem, we'll have a chance to adjust the transcript models when we incorporate RNA-seq data. 
#-g maximum gap allowed between read mappings (of the same transcript model, I presume?). Jose specified 50; DEFAULT IS DIFFERENT WHEN YOU RUN stringtie --help (250) COMPARED TO WHAT GITHUB LISTS (50)
#-p number of threads to use.  
#-M fraction of bundle allowed to be covered by multi-hit reads (default is 1 according to --help command, which should always be checked, I guess). NA, we only have primary alignments in this dataset. Revisit this parameter if you'd like to have secondary alignments contribute to coverage (with a bit of penalty of course) 
#https://github.com/gpertea/stringtie
#very helpful explanations of the parameters:https://ugene.net/wiki/display/WDD31/Assemble+Transcripts+with+StringTie+Element
#-g flag seemed to be the flag Jose focused on. If you have higher max gap between read mappings (250), looks like stringtie tended to combine close-together genes. And I guess if you made it more stringent (50 bp gap) it tended to not combine them as much(?). This will be very important for something like the DAM cluster on Chr1. 
#FYI, stringtie merge will be helpful if you need to merge multiple gtf files. I may need this for the demultiplexed fastqs. - correction 2/8/21; Kevin said just pool the reads, no need for demultiplexing for gene finding. Pay attention to that later if you're interested in tissue-specific expression. 
#Is there a con to decreasing g? Can we go so low that it becomes detrimental to transcript assembly? I'll go with 50 and see what the transcripts look like, I suppose. 


#ONCE YOU GET THE GTF file, like the RNAseq gtf, you need to covert it to a .gff3 and edit some of the features in the file. I first converted the .gtf to a gff3 with cufflinks:

#gffread -E transcripts.gtf -o- > transcripts.gff3

#To be compatible with MAKER, the feature source must be est2genome, and the feature types must be expressed_sequence_match and match_part... DO:::

#sed -i 's/StringTie/est2genome/g' transcripts.gff3
#sed -i 's/transcript/expressed_sequence_match/g' transcripts.gff3
#sed -i 's/exon/match_part/g' transcripts.gff3

#hooray! your transcripts.gff3 file is now MAKER ready :)