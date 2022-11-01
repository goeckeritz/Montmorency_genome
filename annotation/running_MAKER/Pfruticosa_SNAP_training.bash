#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J train_SNAP
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/SNAP/SNAP_train1_fruticosa_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10
module load SNAP/2013-11-29

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/SNAP/

#train SNAP with the results of the first MAKER run. You have to extract the gffs into one gff and fastas into one fasta. See directions in 
#1. Campbell MS, Holt C, Moore B, Yandell M: Genome Annotation and Curation Using MAKER and MAKER-P. 2014.

maker2zff -x 0.2 /mnt/scratch/goeckeri/MAKER_P/fruticosa_run1.maker.output/fruticosa_run1.all.gff
fathom -categorize 1000 genome.ann genome.dna
fathom -export 1000 -plus uni.ann uni.dna
forge export.ann export.dna
hmm-assembler.pl Pfruticosa . > Pfruticosa.hmm

#add the path to your .hmm to your maker_opts.ctl file for the 2nd run of MAKER!