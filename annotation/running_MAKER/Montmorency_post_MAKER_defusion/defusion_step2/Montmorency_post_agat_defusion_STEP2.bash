#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J defusion
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/2_detect_fused_genes_post_agat%j

module purge
conda activate defusion #something is wrong with my defusion_May22 environment. ughhhhhh. step 1 ran fine though... 

#This is where the magic happens, babyyyyyy. defusion's step2 essentially takes the areas in your .brk file and locally reruns MAKER on them
#So you're sort of running step 2 again, but there are some differences. 
#The .ctl file has some changes in it. Namely, we had to extract the transcript sequences from our RNAseq and nanopore data so they'd be in a .fasta format.
#You can do that with gffread (function in cufflinks). example: gffread input.gff -g assembly.fasta -w transcripts.fasta
#You can also use the agat_sp_extract_sequences.pl script in agat. 
#We also use raw protein fastas rather than exonerate alignments. You can use your STANDARD proteins.fasta as evidence along with the uniprot and arabidopsis protein datasets.
#make sure you change the directory of your TMP folder, too. 
#Another crucial thing in the .ctl file that is changed is the min_contig=
#it MUST be set to 1 if you want all regions to be reannotated. That's the minimum size of the region defusion's step2 bothers to reannotate.
#The -c flag should lead to the directory where your .ctl files are. And unfortunately they can't have funny names - cuz the scripts specifically look for the maker_opts.ctl, maker_exe.ctl, and maker_bopts.ctl files. 

export AUGUSTUS_CONFIG_PATH="/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config"

python /mnt/home/goeckeri/deFusion_May22/defusion/defusion/2_extract_to_maker.py -i /mnt/home/goeckeri/genome_files/mont/annotation_prep/montAv5_p99_400k_final/A__not_A%/montAv5_FULL_FINAL_A__.fasta -d /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/mont_step1_post_agat/gff.db -c /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/ -t /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/mont_step1_post_agat/Montmorency_break_coordinates_FINAL_6_10_22.brk -n 24 -p /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/step2_post_agat -v

#the input gff.db is a sqlite database produced from a rerun of defusion's first step. While scouting for fused genes, I found some genes that ought to be removed to better the annotation. So then I needed to produce a special database from that .gff for giving to defusion step 2.  
#If augustus suddenly fails, double check the executable for /agustus navigates to the augustus in your defusion installation! (look in the maker_exe.ctl file)
#this may occur for other dependencies too - so modify the maker_exe.ctl file as needed.




