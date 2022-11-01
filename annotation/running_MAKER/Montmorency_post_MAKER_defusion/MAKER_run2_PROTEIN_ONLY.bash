#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J MAKER2
#SBATCH --time 23:59:00
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=24g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/maker_run2_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

cd /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/

export AUGUSTUS_CONFIG_PATH="/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config"
export AUGUSTUS_SCRIPTS_PATH="/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/scripts"
export AUGUSTUS_BIN_PATH="/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/bin"


#use create the control files from regular run1 of MAKER, except modify the .ctl so that only protein evidence is passed to the Augustus

mpiexec -n 28 maker -base Pcerasus_run2_montAv5_p99_400k_rerun_PROTEIN_ONLY maker_opts_RUN2_PROTEIN_ONLY.ctl maker_bopts.ctl maker_exe.ctl

#MAKER run #2 was run separately using ONLY the protein evidence. The idea behind this was 
#to find out where multiple different protein evidence was aligning to the same gene. 
#That would be a candidate for a fusion. Either it is actually real and there are multiple 
#complex protein domains in a prediction, OR it might indicate that multiple proteins are mapping
#there because the 1 gene prediction really should be several.
#We extract the results like normal, 
#then run some commands to see how many protein hits there are per gene model. We 
#look at all of the ones with 2 or more!
#after we extract the results, we do an interproscan array job against the proteins.fasta
#as per usual to get gene predictions with known protein domains and filter out garbage. 
#we find gene candidates with the STANDARD gene prediction set that was created using only protein evidence. 
#Make sense? :)
#NOTE - I don't have a separate script for extracting the results again because it's pretty routine. 
#SEE Montmorency_extract_MAKER_results_run1.bash FOR EXAMPLE