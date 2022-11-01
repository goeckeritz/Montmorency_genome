#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J V2_frut_bowtie_assemblyA
#SBATCH -A general
#SBATCH --time 120:00:00
#SBATCH --nodes=24
#SBATCH --ntasks=48
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=16g
#SBATCH -o /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/V2_frut_bowtieA_contigs_V2_%j

module load GNU/7.3.0-2.30  OpenMPI/3.1.1-CUDA
module load Bowtie2/2.3.4.2
module load SAMtools/1.9


bowtie2-build /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/fruticosaA.contigs.V2.fasta /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frutA_contigs_V2
bowtie2 -x /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frutA_contigs_V2 \
-1 /mnt/home/goeckeri/genome_files/fruticosa/FRU02_S8_L002_R1_001.fastq.gz \
-2 /mnt/home/goeckeri/genome_files/fruticosa/FRU02_S8_L002_R2_001.fastq.gz \
-S /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frut_assemblyA_contigs_bt2_V2.sam
samtools view -b /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frut_assemblyA_contigs_bt2_V2.sam > /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frut_assemblyA_contigs_bt2_V2.bam
samtools sort -o /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frut_assemblyA_contigs_bt2_sorted_V2.bam /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frut_assemblyA_contigs_bt2_V2.bam
samtools index /mnt/scratch/goeckeri/fruticosa/pilonA_frut/run2_contigs/frut_assemblyA_contigs_bt2_sorted_V2.bam

#Script to align illumina reads to an assembly. The final .bam file is used with pilon to polish the assembly.