#!/bin/sh --login
#SBATCH -J TRIM_RNA_seq
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem-per-cpu=8g
#SBATCH --time=24:00:00
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/TRIMMOMATIC/trimmomatic1_%j
#SBATCH -a 1-25
#SBATCH --export=INFILE=/mnt/home/goeckeri/genome_files/mont/RNA_seq/RNA_seq_files.txt

module purge
module load Trimmomatic/0.39-Java-11

cd /mnt/scratch/goeckeri/RNA_seq/TRIMMOMATIC/

FILE=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE}`
echo ${FILE}
Read1=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE}`
echo ${Read1}
Read2=$(echo ${Read1}| sed "s/R1/R2/")
echo ${Read2}
Name=$(echo ${FILE}| sed 's/\/mnt\/home\/goeckeri\/genome_files\/mont\/RNA_seq\///' | sed "s/_R1_.*//")
echo ${Name}

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar \
PE -phred33 -threads 16 \
${Read1} \
${Read2} \
${Name}_R1_paired_trimmed.fastq.gz ${Name}_R1_unpaired_trimmed.fastq.gz \
${Name}_R2_paired_trimmed.fastq.gz ${Name}_R2_unpaired_trimmed.fastq.gz \
ILLUMINACLIP:/mnt/home/goeckeri/genome_files/mont/RNA_seq/TruSeq3-PE.fa:2:30:10 \
SLIDINGWINDOW:4:15 \
LEADING:5 \
TRAILING:5 \
MINLEN:45 \
AVGQUAL:15

#this script is an array job I submitted to our SLURM scheduler to process all of my RNAseq files from Montmorency (remove adapters, low-quality bases, etc)
#The exported INFILE is just a text file with the exact paths to every one of my R1 files (we had paired-end reads) - one file per line. That's the number of array jobs.
#since R2 is named the exact same as R1, the Read2 variable gets defined as simply the same as R1 but we replace R1 with R2.
#I define the Name variable based on the library name, but to do that, I have to remove the path attached to every R1 line, and everything after R1.
#I've uploaded the RNA_seq_files.txt for Montmorency - see that to know exactly what my files looked like.