#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J train_Augustus
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.maker.output/Augustus/Augustus_%j

module purge
ml -* ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222  BLAT/3.5 MAKER/2.31.10

cd /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.maker.output/Augustus/

./train_augustus_edited.bash /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.maker.output/Augustus /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.all.gff Pcerasus /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.all.maker.transcripts.fasta

#in the Augustus/ working directory, you'll also need two scripts, and to activate them with chmod u+x
# fathom_to_genbank.pl
# get_subset_of_fastas.pl <-- both can be found on Childs lab github.
# you might have to fix the interpreter line of get_subset_of_fastas.pl to #!/usr/bin/perl -w 
# hpcc had to install BLAT, a dependency of Augustus, needed during the autoAug.pl script, I think. 
# after fixing all these issues, I had to delete all files in the half-ass problematic attempts to get this to work.
# be sure to delete the species folder in the config/species folder if you want to redo the augustus training - this includes after ANY FAILED RUNS
# see train_augustus_edited.sh to see what I had to change to get AUGUSTUS to run. 