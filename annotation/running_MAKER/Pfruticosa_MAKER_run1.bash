#!/bin/sh --login
#SBATCH --mail-user=goeckeri@msu.edu
#SBATCH -J MAKER1
#SBATCH --time 23:59:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=20g
#SBATCH -o /mnt/scratch/goeckeri/MAKER_P/maker_run1_fruticosa_%j

module purge
module load ifort/2018.3.222-GCC-7.3.0-2.30  impi/2018.3.222
module load MAKER/2.31.10

cd /mnt/scratch/goeckeri/MAKER_P/

#create the control files
#maker -CTL

#add appropriate parameters to the maker_opts.ctl file 


mpiexec -n 24 maker -base fruticosa_run1 maker_opts_fruticosa1.ctl maker_bopts.ctl maker_exe.ctl

#train SNAP and AUGUSTUS with the resulting MAKER files. 