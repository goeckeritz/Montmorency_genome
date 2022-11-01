#!/bin/sh

#for use on msu's hpcc
ml GCC/8.3.0  CUDA/10.1.243  OpenMPI/3.1.4
ml netCDF-Fortran/4.5.2

#make a new directory where the nexus files for every one of your bootstraps will go. 
#mkdir topology_6_bootstrap_nexus_files
cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/polyploidy_event_est/topology_6_bootstrap_nexus_files

#inside that directory, create another called r8s_output
#mkdir r8s_output

#create a simple nexus file for every bootstrap (n=500) made by RAxML and put the files in their own directory
for i in {1..500}; do
touch bs_tree$i.txt
echo "#nexus" >> bs_tree$i.txt
echo "begin trees;" >> bs_tree$i.txt
echo "$(echo "tree $i = $(sed -n $(echo $i)p /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/polyploidy_event_est/combined_topology6_species_MSAs.fa.raxml.bootstraps)")" >> bs_tree$i.txt
echo "end;" >> bs_tree$i.txt
done

#add the r8s block to every file; by definition, every bootstrap replicate has the same number of sampled sites as the original alignment. 
#see the manual and the paper https://academic.oup.com/bioinformatics/article/19/2/301/372781 to choose the best parameters for your situation.
for i in $(ls -1 bs_tree*.txt); do
echo "
begin r8s;
blformat lengths=persite nsites=128633 ultrametric=no; 
MRCA Malus_Prunus P_persica M_x_domestica;
MRCA Peach_Cherry P_persica P_avium;
MRCA sweet_ground P_avium P_fruticosa;
MRCA subB_avium P_cerasus_subB P_avium;
MRCA subA_avium P_cerasus_subA P_avium;
MRCA subA___frut P_cerasus_subA__ P_fruticosa;
unfixage taxon=all;
fixage taxon=Malus_Prunus age=95;
constrain taxon=Peach_Cherry min_age=10;
set smoothing=1 rates=gamma;
divtime method=pl algorithm=TN;
set penalty=add;
checkGradient=yes;
showage shownamed=yes;
describe plot=chrono_description;
end;" >> $i
done

#then, run r8s on every bootstrap replicate file. (you have to install it first) 
for i in $(ls -1 bs_tree*.txt); do
/mnt/home/goeckeri/r8s/r8s1.81/src/r8s -b -f $i > ./r8s_output/$(echo $i | sed 's/.txt//g')_output
done

#extract the lines containing the table print out for each node date for every bootstrap and put them side-by-side in their own files. Example of such lines:
# [**]  Malus_Pr   95.00
# [**]  Peach_Ch   15.25
# [**]  sweet_gr   11.45
# [**]  subA___f    4.47
# [**]  subA_avi    8.88
# [**]  subB_avi    1.74

#you can do
#grep -n '\[\*\*\]' bs_tree*_output.txt 
#to find out what lines those are on. Should be the same for every bootstrap if the analysis ran smoothly for each one.  

cd /mnt/gs21/scratch/goeckeri/orthofinder_montAv5_scaffolded/Genomes/RAxML/polyploidy_event_est/topology_6_bootstrap_nexus_files/r8s_output/

#make a directory in r8s_output/ where you will put the node age estimates for each analysis:
#mkdir node_ages

for i in $(ls -1 bs_tree*_output); do
sed -n 137,142p $i | awk '{ print $2,$3 }' > ./node_ages/node_ages_$i 

cd node_ages/

#combine the output files. Then we make a mini-file, one per node, that's one column of node age estimates for every bootstrap. 
cat node_ages*output > 500_bs_node_estimates.txt
grep 'subA_a' 500_bs_node_estimates.txt | awk '{print $2}' > subA_avium_node
grep 'subB_' 500_bs_node_estimates.txt | awk '{print $2}' > subB_avium_node
grep 'sweet' 500_bs_node_estimates.txt | awk '{print $2}' > sweet_ground_node
grep 'Peach_' 500_bs_node_estimates.txt | awk '{print $2}' > peach_cherry_node
grep 'Malus_' 500_bs_node_estimates.txt | awk '{print $2}' > peach_apple_node
grep 'subA___f' 500_bs_node_estimates.txt | awk '{print $2}' > subA___fruticosa_node


#go into the 5 files and add a header for each... or you could paste them together first and just add a line with tabs separating the names of each column
#Then paste them together into one file.  

paste subA_avium_node subB_avium_node sweet_ground_node peach_cherry_node peach_apple_node subA___fruticosa_node > topology6_500bs_estimates_node_ages.txt

#Next, calculate 95% confidence intervals for each node age in R. (see calculate_confidence_intervals_for_r8s_top6_top7.R)

 

 
