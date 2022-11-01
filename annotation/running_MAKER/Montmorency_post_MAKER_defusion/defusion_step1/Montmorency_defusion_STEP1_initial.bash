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
conda activate defusion_May22

python /mnt/home/goeckeri/deFusion_May22/defusion/defusion/1_detect_fused_gene.py --input /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_montAv5_p99_400k_STANDARD.all.maker.transcripts.fasta -g /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/Pcerasus_montAv5_p99_400k_STANDARD.all.gff -n 24 -b /mnt/home/goeckeri/miniconda3/envs/defusion_May22/bin/blastn -p /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/Pcerasus_run2_montAv5_p99_400k_rerun_AGAIN.maker.output/defusion/mont_step1 -f -v

#forewarning... defusion can be a pain in the ass to install. If you get stuck, ask Jie for help on his GitHub page. He's very helpful! :)
#this run will create a .brk file with candidates that you also will need to check for fusions. e
