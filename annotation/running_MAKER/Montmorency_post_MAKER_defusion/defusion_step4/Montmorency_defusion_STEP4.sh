#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J defusion
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/step4_%j

module purge
conda activate defusion #something is wrong with my defusion_May22 environment. ughhhhhh. step 1 ran fine though... 

export AUGUSTUS_CONFIG_PATH="/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config"
#export AUGUSTUS_SCRIPTS_PATH="/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/scripts"
#export AUGUSTUS_BIN_PATH="/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/bin"


python /mnt/home/goeckeri/deFusion_May22/defusion/defusion/4_run_maker_standard.py -t /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/merged_defused_transcripts.fa -p /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/merged_defused_protein.fa -g /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/merged_defused.all.mod.gff -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/montAv5_p99_400k_step4 -a /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/Pfam-A.hmm --pfam_cutoff 0.0000000001 -v

#running maker STANDARD to remove genes w/ out Pfam domains, replaces the perl scripts that Kevin made on the github. 


#the final files from this can be further filtered for proteins with TE-related domains, but I didn't bother with Montmorency.
#in fact, I don't think it's all that necessary - worst case scenario you have a couple thousand extra genes that may or may exhibit biological function. 