#!/bin/sh --login
#SBATCH -J STARXS
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem-per-cpu=12g
#SBATCH --time=24:00:00
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR/STAR1_fruticosa_XS_%j
#SBATCH -a 1-14
#SBATCH --export=INFILE1=/mnt/scratch/goeckeri/RNA_seq/fruticosa/TRIMMOMATIC/paired/RNA_seq_paired.txt

module purge
module use /mnt/home/johnj/software/modulefiles
module load GCC/7.3.0-2.30  OpenMPI/3.1.1-CUDA
module load STAR/2.7.3a


fruticosa_contigs=/mnt/home/goeckeri/genome_files/fruticosa/fruticosaA.contigs.V4.descending.renamed.fasta
STAR_fruticosa_index=/mnt/home/goeckeri/genome_files/fruticosa/STAR_fruticosa_index/


FILE1=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE1}`
echo ${FILE1}
Read1_compressed=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE1}`
echo ${Read1_compressed}
Read2_compressed=$(echo ${Read1_compressed}| sed "s/R1/R2/")
echo ${Read2_compressed}
Name=$(echo ${FILE1}| sed 's/\/mnt\/scratch\/goeckeri\/RNA_seq\/fruticosa\/TRIMMOMATIC\/paired\///' | sed "s/_R1_.*//")
echo ${Name}
Read1=$(echo ${Read1_compressed}| sed "s/\.gz//")
echo ${Read1}
Read2=$(echo ${Read2_compressed}| sed "s/\.gz//")
echo ${Read2}

cd /mnt/scratch/goeckeri/RNA_seq/fruticosa/TRIMMOMATIC/paired
gunzip -c ${Read1_compressed} > ${Read1}
gunzip -c ${Read2_compressed} > ${Read2}


cd /mnt/scratch/goeckeri/RNA_seq/fruticosa/STAR

STAR --runMode alignReads --runThreadN 28 --genomeDir $STAR_fruticosa_index --readFilesIn ${Read1} ${Read2} --outSAMtype BAM SortedByCoordinate --outSAMmultNmax 6 --outSAMattributes NH HI AS nM XS --outFilterMismatchNoverLmax 0.15 --outFilterScoreMinOverLread 0.75 --alignIntronMax 7000 --alignSoftClipAtReferenceEnds No --outFileNamePrefix ${Name}_output --outTmpDir ${Name}_tmp --outStd BAM_SortedByCoordinate > ${Name}_sorted.bam

#see Montmorency equivalent of this file for notes
