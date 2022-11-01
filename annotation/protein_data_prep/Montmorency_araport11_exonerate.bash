#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J Athaliana_exonerate
#SBATCH --time 120:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/exonerate/montAv5_p99_400k/Athaliana_exonerate_%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load Exonerate/2.2.0 

cd /mnt/scratch/goeckeri/exonerate/montAv5_p99_400k/

echo "Starting arabidopsis exonerate runs at..."
date
wait

montAv5_p99_400k_full=/mnt/home/goeckeri/genome_files/mont/annotation_prep/montAv5_p99_400k_final/montAv5_p99_FULL_FINAL.fasta
proteins=/mnt/scratch/goeckeri/exonerate/Araport11_genes.201606.pep.fasta

exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 1 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk1 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 2 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk2 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 3 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk3 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 4 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk4 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 5 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk5 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 6 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk6 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 7 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk7 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 8 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk8 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 9 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk9 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 10 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk10 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 11 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk11 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 12 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk12 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 13 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk13 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 14 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk14 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 15 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk15 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 16 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk16 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 17 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk17 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 18 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk18 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 19 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk19 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 20 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk20 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 21 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk21 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 22 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk22 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 23 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk23 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 24 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk24 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 25 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk25 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 26 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk26 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 27 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk27 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 28 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk28 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 29 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk29 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 30 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk30 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 31 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk31 &
exonerate --model protein2genome --bestn 5 --fsmmemory 10000 --minintron 10 --maxintron 5000 --query $proteins --target $montAv5_p99_400k_full --showtargetgff yes --showalignment no --ryo ">%qi length=%ql alnlen=%qal\n>%ti length=%tl alnlen=%tal\n" --targetchunkid 32 --targetchunktotal 32 > montAv5_p99_400k_full_exonerate_chunk32 &

wait
echo "Complete! Time is:"
date

#bruh, you gotta run exonerate in chunks like this or IT WILL RUN FOR THE REST OF YOUR LIFE IT'S SO SLOW
#concatenate all the chunks when it finishes. 
#to clean up the file and convert it to .gff3, I used this script: http://arthropods.eugenes.org/EvidentialGene/evigene/scripts/process_exonerate_gff3.perl
#have perl loaded and do::
#./process_exonerate_gff3.pl -t Protein mont_exonerate_combined.gff3 > mont_exonerate_combined2.gff3 

#Next, you need to replace some terms in this new file, similar to when you had to change terms in the transcripts files. Do the following commands - note that the i flag edits your file in place. 
#sed -i 's/exonerate:protein2genome:local/protein2genome/g' mont_exonerate_combined2.gff3 
#sed -i 's/mRNA/protein_match/g' mont_exonerate_combined2.gff3 
#sed -i 's/CDS/match_part/g' mont_exonerate_combined2.gff3 

#wahoooooooo your protein file is good to go.







#Starting exonerate runs at...
#Fri Feb 26 19:39:53 EST 2021
#Complete! Time is:
#Tue Mar  2 04:25:32 EST 2021


#notes
#https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate-manual
#--bestn = report the best # of results for each query, but only the best ones scoring over a certain threshold. 
#--minintron minimum size of introns; apparently, this flag and maxintron isn't a hard limit, it only is for 'heuristic alignments,' which are... alignments that are menat to be fast and only approximate before narrowing down the possibilities to find more formal alignments, I think. So lowering this probably just... helps with memory usage, I'm guessing. "A heuristic, or a heuristic technique, is any approach to problem solving that uses a practical method or various shortcuts in order to produce solutions that may not be optimal but are sufficient given a limited timeframe or deadline"
#--maxintron max size of introns (I upped it to 5000 based on my quick browsing of the minimap alignments... there was one gene model I saw with like... a 6-7 kb intron.. don't think that's very usual, and it could be wrong -- but we'll start less conservative). but this is for heuristic alignments so it isn't a strict cutoff...
#--targetchunkid essentially allows you to split up the target sequence into chunks so that (I believe) you can run exonerate on multiple threads.
#--ryo is 'roll your own output format'. I got the format listed here from Jose's notes. I guess its a C++ thing.. It essentially says this:
#report the query id %qi, then create a feature called length, which is the query's length %ql, then make another feature called alnlen (alignment length), which is the query's length of alignment, from start to end, in the region it aligns to... then add another line to this feature reporting the id of the target sequence it aligns to. next, make another length feature, list the target's legnth that the corresponding query aligned to; finally, make another alnlen feature for the start to end coordinates(?) of the target sequence that the query aligns to. 

