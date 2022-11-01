#!/bin/sh --login
#SBATCH -J TRIM_RNA_seq
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem-per-cpu=8g
#SBATCH --time=24:00:00
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/fruticosa/TRIMMOMATIC/trimmomatic1_%j
#SBATCH -a 1-28
#SBATCH --export=INFILE=/mnt/home/goeckeri/genome_files/fruticosa/RNA_seq/RNA_seq_fruticosa.txt

module purge
module load Trimmomatic/0.39-Java-11

cd /mnt/scratch/goeckeri/RNA_seq/fruticosa/TRIMMOMATIC/

FILE=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE}`
echo ${FILE}
Read1=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE}`
echo ${Read1}
Read2=$(echo ${Read1}| sed "s/R1/R2/")
echo ${Read2}
Name=$(echo ${FILE}| sed 's/\/mnt\/home\/goeckeri\/genome_files\/fruticosa\/RNA_seq\///' | sed "s/_R1_.*//")
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

#see Montmorency equivalent of this file for notes