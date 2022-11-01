#!/bin/sh --login
#SBATCH -J STARXS
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem-per-cpu=12g
#SBATCH --time=24:00:00
#SBATCH -o /mnt/scratch/goeckeri/RNA_seq/STAR/montAv5_p99_400k/montAv5_p99_400k_%j
#SBATCH -a 1-25
#SBATCH --export=INFILE1=/mnt/scratch/goeckeri/assembly19D_annotation/TRIMMOMATIC/paired/RNA_seq_paired.txt

module purge
module use /mnt/home/johnj/software/modulefiles
module load GCC/7.3.0-2.30  OpenMPI/3.1.1-CUDA
module load STAR/2.7.3a


montAv5_p99_400k_full=/mnt/home/goeckeri/genome_files/mont/annotation_prep/montAv5_p99_400k_final/montAv5_p99_FULL_FINAL.fasta
montAv5_p99_400k_index=/mnt/scratch/goeckeri/STAR_index/

FILE1=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE1}`
echo ${FILE1}
Read1_compressed=`/bin/sed -n ${SLURM_ARRAY_TASK_ID}p ${INFILE1}`
echo ${Read1_compressed}
Read2_compressed=$(echo ${Read1_compressed}| sed "s/R1/R2/")
echo ${Read2_compressed}
Name=$(echo ${FILE1}| sed 's/\/mnt\/scratch\/goeckeri\/assembly19D_annotation\/TRIMMOMATIC\/paired\///' | sed "s/_R1_.*//")
echo ${Name}
Read1=$(echo ${Read1_compressed}| sed "s/\.gz//")
echo ${Read1}
Read2=$(echo ${Read2_compressed}| sed "s/\.gz//")
echo ${Read2}

#cd /mnt/scratch/goeckeri/assembly19D_annotation/TRIMMOMATIC/paired/
#gunzip -c ${Read1_compressed} > ${Read1}
#gunzip -c ${Read2_compressed} > ${Read2}

cd /mnt/scratch/goeckeri/RNA_seq/STAR/montAv5_p99_400k/
STAR --runMode alignReads --runThreadN 28 --genomeDir $montAv5_p99_400k_index --readFilesIn ${Read1} ${Read2} --outSAMtype BAM SortedByCoordinate --outSAMmultNmax 6 --outSAMattributes NH HI AS nM XS --outFilterMismatchNoverLmax 0.15 --outFilterScoreMinOverLread 0.75 --alignIntronMax 7000 --alignSoftClipAtReferenceEnds No --outFileNamePrefix ${Name} --outTmpDir ${Name}_tmp --outStd BAM_SortedByCoordinate > ${Name}_sorted.bam

#this script is the one I used to mapped my processed RNAseq reads to my genome.
#don't forget to make the STAR index for your genome before alignment.
#See the Montmorency TRIMMOMATIC script to understand why the SLURM script is structured this way. The INFILE for this array job
#is similar to the RNA_seq_files.txt, but now we're pointing to different files to align to the genome. 
#NOTE - I commented out the 34-36 lines because I ran the script with those uncommented FIRST and while lines 38-39 were commented out.
#then when I had uncompressed reads for alignment I commented 34-36 again and uncommented lines 38-39 to run the alignment. Hope that makes sense... 