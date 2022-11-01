#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J combine_sort_index_montAv5_p99_400k
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/STAR/montAv5_p99_400k/combine_sort_index_no_filterXS_%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load SAMTools/1.9

cd /mnt/scratch/goeckeri/RNA_seq/STAR/montAv5_p99_400k/

samtools merge -@ 28 MNT_combined.bam MNT_C1A_S2_L001_sorted.bam MNT_C1C_S4_L001_sorted.bam MNT_C2A_S56_L007_sorted.bam MNT_C2B_S57_L008_sorted.bam MNT_C2C_S58_L008_sorted.bam MNT_C3C_S23_L006_sorted.bam MNT_C3E_S24_L006_sorted.bam MNT_C3F_S25_L007_sorted.bam MNT_FA_S27_L003_sorted.bam MNT_FB_S29_L003_sorted.bam MNT_FC_S35_L004_sorted.bam MNT_FLESHA_S69_L008_sorted.bam MNT_FLESHB_S70_L008_sorted.bam MNT_FLESHE_S71_L008_sorted.bam MNT_LC_S41_L005_sorted.bam MNT_LC_S7_L006_sorted.bam MNT_LD_S42_L005_sorted.bam MNT_LF_S43_L005_sorted.bam MNT_SA_S7_L001_sorted.bam MNT_SB_S8_L001_sorted.bam MNT_SC_S60_L007_sorted.bam MNT_SKINA_S72_L008_sorted.bam MNT_SKINB_S67_L008_sorted.bam MNT_SKINC_S68_L008_sorted.bam
samtools sort -o MNT_combined_sorted.bam -@ 28 MNT_combined.bam 
samtools index -@ 28 MNT_combined_sorted.bam
samtools flagstat -@ 28 MNT_combined_sorted.bam > MNT_combined_sorted_flagstat

#this script serves to combine all of my aligned RNAseq files. After I aligned them with STAR, I combined them to make file handling easier.
#After they are combined and sorted, it's time to make our transcriptome with StringTie... (that's the next step)
#flagstat command will give you some stats on all your reads. Always good to check them out. 

