#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J defusion
#SBATCH --time 24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/1_detect_fused_genes_%j

module purge
conda activate defusion

python /mnt/home/goeckeri/deFusion_May22/defusion/defusion/1_detect_fused_gene.py --input /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_montAv5_p99_400k_STANDARD.all.sorted.clean.post_agat_transcripts.fasta -g /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_montAv5_p99_400k_STANDARD.all.sorted.clean.post_agat.gff -n 24 -b /mnt/home/goeckeri/miniconda3/envs/defusion_May22/bin/blastn -p /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/mont_step1_post_agat -f -v

#don't forget to get new transcript and proteins file from the post-agat .gff before this step with get_subset_of_fastas.pl

#after we remove genes identified from manually scouting the candidates (with agat), you HAVE to rerun defusion step1 because the gff database that is created
#is specific to the .gff file, and if it finds a bunch of discrepancies in this new file when you run step2, defusion will freak out.
#So, whole purpose of this rerun is to get the new gff database that will be used in step2. 