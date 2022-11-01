#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J lastal
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12g
#SBATCH -o /mnt/scratch/goeckeri/MCScan_%j

module purge
module load icc/2017.4.196-GCC-6.4.0-2.28  impi/2017.3.196
module load Python/3.7.2
module load texlive/20210316
module load LAST/914

cd /mnt/home/goeckeri/software/jcvi

source jcvi/bin/activate

cd /mnt/gs21/scratch/goeckeri/MCScan/

python -m jcvi.formats.gff bed --type=mRNA --key=ID /mnt/gs21/scratch/goeckeri/MCScan/subgenomeA.gff3 -o subA.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID /mnt/gs21/scratch/goeckeri/MCScan/subgenomeA__.gff3 -o subA__.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID /mnt/gs21/scratch/goeckeri/MCScan/subgenomeB.gff3 -o subB.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID /mnt/gs21/scratch/goeckeri/MCScan/Prunus_avium_Tieton.annotation.gff3 -o tieton.bed
python -m jcvi.formats.gff bed --type=mRNA --key=ID /mnt/gs21/scratch/goeckeri/MCScan/Pfruticosa_final_6_21_22.gff3 -o fruticosa.bed

python -m jcvi.formats.fasta format /mnt/gs21/scratch/goeckeri/MCScan/subAcds.fasta subA.cds
python -m jcvi.formats.fasta format /mnt/gs21/scratch/goeckeri/MCScan/subA__cds.fasta subA__.cds
python -m jcvi.formats.fasta format /mnt/gs21/scratch/goeckeri/MCScan/subBcds.fasta subB.cds
python -m jcvi.formats.fasta format /mnt/gs21/scratch/goeckeri/MCScan/Prunus_avium_Tieton.cds-transcripts.fasta tieton.cds
python -m jcvi.formats.fasta format /mnt/gs21/scratch/goeckeri/MCScan/Pfruticosa_final_cds_6_21_22.fasta fruticosa.cds

python -m jcvi.compara.catalog ortholog subA tieton --no_strip_names
python -m jcvi.compara.catalog ortholog subA__ tieton --no_strip_names
python -m jcvi.compara.catalog ortholog subB tieton --no_strip_names
python -m jcvi.compara.catalog ortholog subA fruticosa --no_strip_names
python -m jcvi.compara.catalog ortholog subA__ fruticosa --no_strip_names
python -m jcvi.compara.catalog ortholog subB fruticosa --no_strip_names


python -m jcvi.compara.synteny depth --histogram subA.tieton.anchors
python -m jcvi.compara.synteny depth --histogram subA__.tieton.anchors
python -m jcvi.compara.synteny depth --histogram subB.tieton.anchors
python -m jcvi.compara.synteny depth --histogram subA.fruticosa.anchors
python -m jcvi.compara.synteny depth --histogram subA__.fruticosa.anchors
python -m jcvi.compara.synteny depth --histogram subB.fruticosa.anchors


#

