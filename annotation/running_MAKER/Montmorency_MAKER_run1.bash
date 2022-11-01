#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J MAKER1
#SBATCH --time 48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20g
#SBATCH -o /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/maker_run1_montAv5_p99_400k_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

cd /mnt/scratch/goeckeri/montAv5_p99_400k_MAKER/

#create the control files
#maker -CTL

#add appropriate parameters to the maker_opts.ctl file 


mpiexec -n 24 maker -base Pcerasus_run1_montAv5_p99_400k maker_opts.ctl maker_bopts.ctl maker_exe.ctl

#I used this script purely to launch MAKER. All my parameters are detailed in the maker_opts_file.
#If you take a look at the document from the Childs lab, they give some great tips on paramater choice and walk you through annotation
