#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J iprscan
#SBATCH --time 120:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/add_functions/iprscan_%j

module purge
module load icc/2018.1.163-GCC-6.4.0-2.28  impi/2018.1.163
module load InterProScan/5.47-82.0

#Don't do this until after you have renamed your genes in a standard format.

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/add_functions/

interproscan.sh -appl Pfam, TIGRFAM, PANTHER -goterms -f TSV -b fruticosa -cpu 32 -i /mnt/home/goeckeri/genome_files/fruticosa/post_apollo/renamed/fruticosa_postTEs_post_apollo_combined_proteins.fasta


#gives you a nice table of database numbers for Pfam, TIGRFAM, etc.
#I grabbed each database name to make separate tables for each, and did some quality filtering and txt file modification to fill in weird spaces in the file. 

#EXAMPLE TO MAKE THE PANTHER FUNCTIONAL FILE:
#awk 'BEGIN{FS=OFS="\t"} ($4=="PANTHER") && ($9<=1.0E-10)' file.tsv | awk 'BEGIN{FS=OFS="\t"} $12==""{$12="-"}1' | awk 'BEGIN{FS=OFS="\t"} $13==""{`$13="-"}1' | awk 'BEGIN{FS=OFS="\t"} $14==""{$14="-"}1'  |awk 'BEGIN{FS=OFS="\t"} {print $1, $4, $5, $6, $12, $13, $14 }'  | awk 'BEGIN{FS=OFS="\t"} !visited[$0]++' > file_PANTHER.tsv 

#what this one-liner means:
#“the separator is tab, extract the lines that have column 4 as PANTHER and column 9 less than or equal to 1E-10. | the separator is tab, take the output from the previous filter and look at column 12. If it’s empty, replace the emptiness with ‘-‘ | <do same thing but with column 13> | <do the same thing with column 14> | the separator is tab, take the output from the previous command and print columns 1, 4, 5, 6, 12, 13, and 14 | the separator is tab, remove duplicate lines."
#I removed duplicated lines 'cuz sometimes a gene would have, say, several of the same protein domain -- and I really only cared to know it was there at least once. 

#Do this with however many databases you'd like. 

#I added one header line to each file afterwards:
#gene    db      dbxref  db_description  IPR     IPR_description GO


