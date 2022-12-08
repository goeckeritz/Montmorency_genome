#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J agat
#SBATCH --time 12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/agat_%j

module purge
conda activate agat

cd /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/

agat_sp_filter_feature_from_kill_list.pl --gff Pcerasus_montAv5_p99_400k_STANDARD.all.sorted.clean.gff --type gene,mRNA,exon,five_prime_UTR,CDS,three_prime_UTR --kill_list genes_to_remove_COMBINED_7A__7B_corrections_and_more.txt --output Pcerasus_montAv5_p99_400k_STANDARD.all.sorted.clean.post_agat.gff 
#https://agat.readthedocs.io/en/latest/tools/agat_sp_filter_feature_from_kill_list.html

#alas, after all my troubleshooting, I could not figure out the errors made recording 1 gene on the kill list. it was on 7B I think
#reported 872 genes were on the kill list. 
#features from 871 were removed - so that checks:

#=> OmniscientI total time: 210 seconds
#Parsing Finished
#8431 features removed:
#871 features level1 (e.g. gene) removed
#871 features level2 (e.g. mRNA) removed
#6689 features level3 (e.g. exon) removed

#next, gotta rerun defusion step1 and completely ignore the break file just so I can have the new .db for step 2. 