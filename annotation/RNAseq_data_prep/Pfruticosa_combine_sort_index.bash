#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J combine_sort_index_fruticosa
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR/combine_sort_index_no_filterXS_%j

module purge
module use /mnt/home/johnj/software/modulefiles
module load SAMTools/1.9

cd /mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR/

samtools merge -@ 28 FRUT_combined.bam FRU02_C1A_S23_L003_sorted.bam FRU02_C1B_S24_L003_sorted.bam FRU02_C1C_S25_L004_sorted.bam FRU02_C2A_S55_L006_sorted.bam FRU02_C2B_S56_L006_sorted.bam FRU02_C2D_S57_L006_sorted.bam FRU02_C3A_S21_L006_sorted.bam FRU02_C3D_S22_L006_sorted.bam FRU02_FA_S47_L005_sorted.bam FRU02_FC_S48_L005_sorted.bam FRU02_FE_S49_L005_sorted.bam FRU02_LA_S25_L003.bam FRU02_LE_S33_L004_sorted.bam FRU02_LF_S34_L004_sorted.bam
samtools sort -o FRUT_combined_sorted.bam -@ 28 FRUT_combined.bam 
samtools index -@ 28 FRUT_combined_sorted.bam
samtools flagstat -@ 28 FRUT_combined_sorted.bam > FRUT_combined_sorted_flagstat

#see Montmorency equivalent of this file for notes