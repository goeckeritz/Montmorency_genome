#! /bin/bash

# Training AUGUSTUS requires scripts and programs from MAKER, BLAT, UCSC Utils, AUGUSTUS.

# MAKER - http://www.yandell-lab.org/software/maker.html
# AUGUSTUS - http://bioinf.uni-greifswald.de/augustus/
# BLAT - http://genome.ucsc.edu/FAQ/FAQblat.html
# UCSC Utils - http://hgdownload.cse.ucsc.edu/admin/exe/

# Additionally, the script, fathom_to_genbank.pl, is required and can be found at github: https://github.com/Childs-Lab/GC_specific_MAKER.

# Kevin Childs

# modified by Charity to get AUGUSTUS to freaking run on the hpcc. 
# So how was it edited from the script in the Childs Lab Github? Generally speaking, I made scripts activate-able by putting ./ or their full path in front of them. 
# e.g., see lines 76, 77, 85, 86, 95, 106, 133, 157
# I also exported the AUGUSTUS_CONFIG_PATH variable every time the script called on any augustus functions. You need to be able to write to the species/ folder inside config/, and 
# I had trouble getting this script to find my personal config folder instead of the one built into our HPCC (which I DO NOT have write access to)
# e.g., see lines 94, 105, 119, 132, 146, 156
# I also used my own AUGUSTUS installation and scripts, I believe. 


WORKING_DIR=$1
MAKER_GFF_FILE_W_FASTA=$2
AUGUSTUS_SPECIES_NAME=$3
CDNA_FASTA=$4


if [[ -z $WORKING_DIR || -z $MAKER_GFF_FILE_W_FASTA || -z $AUGUSTUS_SPECIES_NAME || -z $CDNA_FASTA ]]; then
    echo "Usage: $0 WORKING_DIR  MAKER_GFF_FILE_W_FASTA  AUGUSTUS_SPECIES_NAME   CDNA_FASTA"
    exit 1
elif [ ! -e $MAKER_GFF_FILE_W_FASTA ]; then
    echo "The previous index log file does not exist: $MAKER_GFF_FILE_W_FASTA"
    exit 1
elif [ ! -e $CDNA_FASTA ]; then
    echo "The cDNA fasta file does not exist: $CDNA_FASTA"
    exit 1
fi


# 1. Convert the maker output to zff format using high-quality MAKER gene predictions from a MAKER gff file that also has the genome assembly included.

echo "cd $WORKING_DIR"
cd $WORKING_DIR

echo "maker2zff -x 0.2 -l 200  $MAKER_GFF_FILE_W_FASTA"
maker2zff -x 0.2 -l 200  $MAKER_GFF_FILE_W_FASTA


# output: genome.ann (ZFF file)
#         genome.dna (fasta file that the coordinates in the zff can be referenced againsted)


# 2. use the fathom  script from snap to get the unique annotations

echo "fathom genome.ann genome.dna -categorize 1000"
fathom genome.ann genome.dna -categorize 1000

NUMFOUND="`grep -c '>' uni.ann`"

if [ ${NUMFOUND} -gt 499 ]; then
    NUMFOUND=500
fi

TEMPSPLIT=$((NUMFOUND/2))
NUMSPLIT=${TEMPSPLIT/.*}

echo "number found after fathom: $NUMFOUND"
echo "number after split: $NUMSPLIT"


# 3. Convert the uni.ann and uni.dna output from fathom into a genbank formatted file.
#    fathom_to_genbank.pl is available on github: https://github.com/Childs-Lab/GC_specific_MAKER.
#    Modify the path here, or ensure that fathom_to_genbank.pl is in your $PATH.

echo "./fathom_to_genbank.pl  --annotation_file uni.ann  --dna_file uni.dna  --genbank_file augustus.gb  --number ${NUMFOUND}"
./fathom_to_genbank.pl  --annotation_file uni.ann  --dna_file uni.dna  --genbank_file augustus.gb  --number ${NUMFOUND}

# To get the subset of fastas that correspond to the genes in the genbank file, follow these steps.
#    get_subset_of_fastas.pl is available on github: https://github.com/Childs-Lab/GC_specific_MAKER.
#    Modify the path here, or ensure that get_subset_of_fastas.pl is in your $PATH.

perl -e  'while (my $line = <>){ if ($line =~ /^LOCUS\s+(\S+)/) { print "$1\n"; } }'  ${WORKING_DIR}/augustus.gb  >  ${WORKING_DIR}/genbank_gene_list.txt

echo "./get_subset_of_fastas.pl   -l  ${WORKING_DIR}/genbank_gene_list.txt    -f ${WORKING_DIR}/uni.dna  -o  ${WORKING_DIR}/genbank_gene_seqs.fasta"
./get_subset_of_fastas.pl   -l  ${WORKING_DIR}/genbank_gene_list.txt    -f ${WORKING_DIR}/uni.dna  -o  ${WORKING_DIR}/genbank_gene_seqs.fasta


# 4. Split the known genes into test and training files.
#    randomSplit.pl is a script provided by AUGUSTUS.
#    Modify the path here, or ensure that randomSplit.pl is in your $PATH.

echo "randomSplit.pl ${WORKING_DIR}/augustus.gb ${NUMSPLIT}"
export AUGUSTUS_CONFIG_PATH=/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config
/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/scripts/randomSplit.pl ${WORKING_DIR}/augustus.gb ${NUMSPLIT}


# We will use autoAug.pl for training because we have transcript alignments that will be used as hints.
# The etraining and optimize_augustus.pl scripts from AUGUSTUS will not be used as they do not allow for the use of hints.
# 5. Run autoAug.pl.  
#    This script is provided in the AUGUSTUS installation.
#    Modify the path here, or ensure that autoAug.pl is in your $PATH.

echo "autoAug.pl --species=$AUGUSTUS_SPECIES_NAME --genome=${WORKING_DIR}/genbank_gene_seqs.fasta --trainingset=${WORKING_DIR}/augustus.gb.train --cdna=$CDNA_FASTA  --noutr"
export AUGUSTUS_CONFIG_PATH=/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config
/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/scripts/autoAug.pl --species=$AUGUSTUS_SPECIES_NAME --genome=${WORKING_DIR}/genbank_gene_seqs.fasta --trainingset=${WORKING_DIR}/augustus.gb.train --cdna=$CDNA_FASTA  --noutr


# 6. Run the batch scripts generated by the previous command

cd "${WORKING_DIR}/autoAug/autoAugPred_abinitio/shells"
cd ${WORKING_DIR}/autoAug/autoAugPred_abinitio/shells

# The number of ./aug# scripts is variable.  Run until the new file does not exist.
x=1
while [ -e ./aug${x} ]
do
    echo "A.  $x"
    export AUGUSTUS_CONFIG_PATH=/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config ./aug${x}
    let x=x+1
done


# 7. Run the next command as indicated by autoAug.pl in step 5.

# When above jobs are finished, continue by running the command autoAug.pl

echo "cd $WORKING_DIR"
cd $WORKING_DIR

echo "autoAug.pl --species=$AUGUSTUS_SPECIES_NAME --genome=${WORKING_DIR}/genbank_gene_seqs.fasta --useexisting --hints=${WORKING_DIR}/autoAug/hints/hints.E.gff  -v -v -v  --index=1"
export AUGUSTUS_CONFIG_PATH=/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config
/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/scripts/autoAug.pl --species=$AUGUSTUS_SPECIES_NAME --genome=${WORKING_DIR}/genbank_gene_seqs.fasta --useexisting --hints=${WORKING_DIR}/autoAug/hints/hints.E.gff  -v -v -v  --index=1


# 8. Run the batch scripts as indicated by autoAug.pl in step 7.

echo "cd ${WORKING_DIR}/autoAug/autoAugPred_hints/shells/"
cd ${WORKING_DIR}/autoAug/autoAugPred_hints/shells/

# The number of ./aug# scripts is variable.  Run until the new file does not exist.
let x=1
while [ -e ./aug${x} ]
do
    echo "B.  $x"
    export AUGUSTUS_CONFIG_PATH=/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config ./aug${x}
    let x=x+1
done


# 9. Checked sensitivity and specificity of the newly trained AUGUSTUS HMM by using the test data.

cd ${WORKING_DIR}

echo "augustus --species=$AUGUSTUS_SPECIES_NAME augustus.gb.test"
export AUGUSTUS_CONFIG_PATH=/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config
/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/bin/augustus --species=$AUGUSTUS_SPECIES_NAME augustus.gb.test

#this verson of the script worked, with some complaining. But Kevin confirmed my augustus results and the 'hmm' is actually the whole folder in the config/species/ folder in my software/ in my home directory. Now we've got to get MAKER to find that... and I'm not sure how we're going to do that. Ask the hpcc people to put my new hmm folder in their collection?
#/mnt/home/goeckeri/software/AUGUSTUS/3.3.2-intel-2018b-Python-2.7.15/config/species/Pcerasus