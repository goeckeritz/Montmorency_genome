#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J minimap2
#SBATCH --time 2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/minimap2/montAv5_p99_400k/minimap2_filt150_montAv5_p99_400k_%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load minimap2/2.15.Py3
module load SAMTools/1.9

montAv5_p99_400k=/mnt/home/goeckeri/genome_files/mont/annotation_prep/montAv5_p99_400k_final/montAv5_p99_FULL_FINAL.fasta
pooled_reads=/mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/nanopore_filt150_pooled.fastq.gz

cd /mnt/scratch/goeckeri/nano_temp/fastq_pass/demultiplexing_filt/minimap2/montAv5_p99_400k/

minimap2 -N 5 -t 28 -ax splice -g2000 -G10k $montAv5_p99_400k $pooled_reads | samtools view -@ 28 -Su | samtools sort -@ 28 -O bam -o nanopore_filt150_pooled_montAv5_p99_400k_sorted.bam
samtools index nanopore_filt150_pooled_montAv5_p99_400k_sorted.bam

#this script is for aligning my processed nanopore reads to our genome. 
#check alignments and the transcript assembly in a browser and modify paramaters for your own purposes

#please feel free to read my stupid spit-balling below at your own risk. 


#notes
# -N output, at most, this number of secondary alignments. In other words, alignments beyond the first secondary are TMI. Let's just focus on these first.. I just want primary alignments... so N = 0. This is because  
# -t threads
# -a tells minimap2 we are doing long read alignment with CIGAR, which basically indicates we are doing long-read mapping to a reference genome. 
# -x This option applies multiple options at the same time. It should be applied before other options because options applied later will overwrite the values set by -x. 
# -g stops chain elongation if there are no minimizers within [your number] base pairs. default is 10,000. WTF does this mean. from what I can gather, a minimizer is sort of like a mini kmer in a larger kmer. So I guess if minimap2 can't find a matching minimizer in your genome within a specific length - it just bags the alignment. 
# -G is the maximum gap on the reference. It also changes the chaining and alignment band width to your selected number. It sort of seems like... it is limiting the intron size / limiting the gap size for spliced alignments. the default appears to be
# 200k (yikes). This should be important for genes that are close together in space, and MOST impt for genes in tandem duplication, part of families. 
# So restricting or increasing this will be really impt for correctly distinguishing adjacent genes. 200k is ungodly excessive. Since Kevin's lab had a small genome for their work, and we do too, we shoul make this much smaller. A quick google search of 
# arabidopsis' intron sizes says they are usually 50-300 bp, <1% is bigger than 1 kb, and only 16 in the whole genome are annotated as being more than 5 kb. Granted, our genome is 5-6x the size of arabidopsis. Wonder if that's intergenic space or repeats in introns
# causing the expansion, all other things held constant.. 5k is kinda small, I think I will go with 10k. 
# -@ threads to use for compression in addition to the main thread.
# -S is ignored for compatibility with previous samtools versions. Says to samtools that the incoming file will be a sam file. But I guess later versions of samtools just automatically detects the input file. Can't hurt to have I suppose. 
# -u output is uncompressed BAM. This option saves time spent on compression/decompression and is thus preferred when the output gets piped to another SAMTools command. Don't wanna spend time compressing until we're done with the little pipeline here. 
# -O is the output format... -o is the name of your file. We should get 12 files with the name of the barcode, hopefully XD
# Lastly we index! that will be for ease of use for stringtie. 
