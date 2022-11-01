#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J train_Augustus
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/Augustus/Augustus_fruticosa_run1_%j

module purge
ml -* ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222  BLAT/3.5 MAKER/2.31.10

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/Augustus/

./train_augustus_edited.bash /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/Augustus /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/fruticosa_run1.all.gff Pfruticosa_redo /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/fruticosa_run1.all.maker.transcripts.fasta

#in working directory, also need two scripts, and to activate them with chmod u+x
# fathom_to_genbank.pl
# get_subset_of_fastas.pl <-- both can be found on Childs lab github.
# had to fix interpreter line of get_subset_of_fastas.pl to #!/usr/bin/perl -w 
# prior to that it was something weird, like opt/perl/bin/perl or something
# in train_augustus.bash script, had to add ./ to where fathom_to_genbank.pl and get_subset_of_fastas.pl scripts were executed (line 68 and 77). otherwise the commands couldn't be found. 
# hpcc had to install BLAT, a dependency of Augustus, needed during the autoAug.pl script, I think. 
# after fixing all these issues, I had to delete all files in the half-ass problematic attempts to get this to work.
# also added export config_path to the edited train augustus bash script. Might be a little angry with that but it seems to pull through
# be sure to delete the species folder in the config/species folder if you want to redo the augustus training!


#READ THE COMMENTED LINES IN THE TRAIN_AUGUSTUS_EDITED.BASH SCRIPT, AND THE NOTES IN THE SCRIPT THAT IS EQUIVALENT TO THIS ONE FOR MONTMORENCY