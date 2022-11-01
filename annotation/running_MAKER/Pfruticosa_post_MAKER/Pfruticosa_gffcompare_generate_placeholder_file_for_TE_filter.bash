#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J MSU_RGAP
#SBATCH --time 72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/TE_filtering_gffcompare_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

STANDARD_gff=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/fruticosa_run2_STANDARD.all.gff
MSU_RGAP_gff=/mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/MSU_RGAP_all.gff3

cd /mnt/scratch/goeckeri/MAKER_P/fruticosa_run2.maker.output/KILL_the_TEs/

/mnt/home/goeckeri/gffcompare/gffcompare -o TE_STANDARD_comparisons -r $MSU_RGAP_gff $STANDARD_gff

#So, funny story - the only thing this script does is create an empty file as a placeholder for the next step (TE final filter) - that is, unless you work with rice.
#In Bowman et al., they are working with rice, and they actually get a meaningful file. 
#So why even do this?
#Because if you don't have a placeholder file, the script in the TE final filter process freaks the f*ck out. :)

#i.e., this output acts as a placeholder that the create_no_TE_genelist.py needs to run!