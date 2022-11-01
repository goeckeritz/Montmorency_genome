#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J juicer_montAv5_p99_+400k
#SBATCH --time 96:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=96
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=24g
#SBATCH -o /mnt/scratch/goeckeri/Montmorency/montAv5_p99_with_400k+added_in_%j

# sample work directory is /mnt/scratch/goeckeri/Montmorency/juicer/work/MONT18_25
# Core Juicer scripts from github in /mnt/scratch/goeckeri/Montmorency/juicer/scripts

/mnt/scratch/goeckeri/Montmorency/juicer_400k+/scripts/juicer.sh \
-d /mnt/scratch/goeckeri/Montmorency/juicer_400k+/work/MONT18_25/ \
-s DpnII \
-q horticulture \
-l horticulture \
-S early \
-y /mnt/scratch/goeckeri/Montmorency/juicer_400k+/restriction_sites/montAv5_p99_400k_DpnII.txt \
-z /mnt/scratch/goeckeri/Montmorency/juicer_400k+/references/montAv5_p99_+400k \
-a 'juicer run of montmorency assemblyAv5 after purge haplotigs w/ 99 as align cutoff and 400k+ contigs from the haplotigs fasta added back into the assembly' \
-D /mnt/scratch/goeckeri/Montmorency/juicer_400k+/ \
-A horticulture


#you'll need to make a bwa index of your genome prior to running juicer, which does the alignments for you actually.
#Study the juicer directory structure THOUROUGHLY. Everything must be in the right directories! Think of it as setting your ingredients down in the right place before making a delicious cherry pie.
#Know the restriction enzyme used to make your HiC library - mine was DPnII, and I had to generate the the file for the -y flag. Do that with a script in the aiden lab's repository called generate_site_positions.py
#Example of command: 
# python generate_site_positions.py DpnII genome_name 
#NOTE - easiest way to get this to work is to go INTO the .py script and add a name and path to your genome in the filenames section!!! Do this before you run the above command. 

#End result you need prior to 3D-DNA is a file called merge_nodups.txt
#you should have no dup split .err files anywhere if the juicer pipeline succeeded!

#LINK to aiden lab juicer repository: https://github.com/aidenlab/juicer 

#Don't be afraid to ask their lab for help -- they are wonderful and have a whole google group dedicated to juicer and 3D-DNA and Juicebox Assembly Tools. 
#They also have a 'cookbook' THAT YOU ABSOLUTELY MUST READ. <3 Find the pdf!
 