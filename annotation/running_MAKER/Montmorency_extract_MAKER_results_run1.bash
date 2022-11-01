#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J extract
#SBATCH --time 9:59:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.maker.output/maker_extract_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

cd /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN.maker.output/
#Get the GFFs from all of the directories within the datastore:
gff3_merge -d  Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN_master_datastore_index.log Pcerasus_run1_montAv5_p99_400k.all.gff 

#Get the fastas from proteins and transcripts!
fasta_merge -d Pcerasus_run1_montAv5_p99_400k_rerun_AGAIN_master_datastore_index.log Pcerasus_run1_montAv5_p99_400k.all.proteins.fasta Pcerasus_run1_montAv5_p99_400k.all.maker.transcripts.fasta


#you'll use the .gff3 from the first MAKER run to train your gene finder(s) - we used SNAP+AUGUSTUS for Pfruticosa and just AUGUSTUS for Montmorency.
#Usually AUGUSTUS performs better than SNAP 