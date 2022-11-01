#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J blastn
#SBATCH --time 2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10g
#SBATCH -o /mnt/scratch/goeckeri/markers_ABC/montAv5_p99_400k/blastn_ABC_%j

ml purge
ml BLAST+/2.2.31

cd /mnt/scratch/goeckeri/markers_ABC/montAv5_p99_400k/


#make the database first. Only takes a few minutes on the command line.. 

makeblastdb -in montAv5_p99_400k_chr1-24_round2.fasta -input_type fasta -dbtype nucl

blastn -db montAv5_p99_400k_chr1-24_round2.fasta -query sourcherry_montx25_marker_sequences.txt -out mapped_markers_ABC_montAv5_p99_400k_round2.tsv -evalue 0.0000000001 -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen" -num_alignments 6 -max_hsps 6 -num_threads 24

#we blasted the markers to the assembly several times (hence the round 2 name here) with the same parameters. We then located markers
#on our HiC map and decided whether or not it would be best to order according to the marker order (in some cases it was not - an inversion on chr1A' is an example of this)
