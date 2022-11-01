#Our genome may be problematic. 
#What we thought to be 2 sets of chromosomes, one from avium and one from fruticosa, appear to both be from fruticosa.
#the alt chromosomes are avium-derived. I've been calling this subC since I found out.  
#My hypothesis is that fruticosa is an allotetraploid (making mont's genotype ABCC), explaining why the 2 sets of chromosomes were so easyily assembled. 
#I think the avium subgenome (CC) is in two copies, and because of heterozygosity -- was difficult to assemble due to lots of heterzygous bubbles. 
#maybe the sequence that belonged in the avium subgenome ended up in the fruticosas.. but it doesn't make much sense to me... it should have been randomly scattered throughout the genomes. 
#However, avium was assembled in small contigs.. probably due to bubbles. And if that's the case, contig creation would be biased towards the longer-contig option - which would likely 
#be a fruticosa option if the A and B fruticosas are very different from one another. So..
#the goal in reassembly should be to collapse the avium haplotypes in order to get longer contigs, then prevent common sequences from merging
#during unitigging... a lot of this strategy is going to depend on how different the genomes are from one another..
#Anyway, the focus here is to look at coverage across subA, subB, subC, and 'everything else' to get a sense of what might be going on the assembly. 
#For example, to look at where collapsing might be happening; I wonder if it is happening more in what I suspect is mostly sweet cherry. 
#And if it's not, is it because the contig bubbles have been split so effectively? I wonder. The sequences of avium and fruticosa are probably
# different enough though... otherwise I would have expected much more avium to show up in the longer contig regions of fruticosa.. right?

#Lines (bp per subgenome) in each file before averaging every 100 positions:
#subA	262760747
#subA__ (subA prime) 258552827
#subB	250500329
#everything else 294217262

#individual read depth files without data reduction (e.g., avg per 1000 sites) made files 4+ Gb. So I calculated the median coverage of the three genotypes 
#by first sorting the depth column numerically with 
#sort -n -k 3 file
#and printing the middle line. easy peasy

#used this code to calculate the average of every 1000 data points for each of the 2 columns per subgenome (position and reads mapped). Kinda tedious, had to separate columns first. 
#awk '{sum+=$1} (NR%1000)==0{print sum/1000; sum=0;}' input_file
library(ggplot2)
library(tidyverse)

setwd ("/Users/Goeckeritz/Desktop/Desktop - Charity’s MacBook Pro/cherry_stuff_Charity/Genome_project/coverage/montAv5_p99_400k/")

subA = read.table("subA_100.txt", header=FALSE)
subA_1000 = read.table("subA_1000.txt", header=FALSE)
#ggplot(data=subA, aes(x=V2, y=V3)) +
  #geom_point(size=0.1) +
  #ggtitle("subA coverage, chr concatenated end-to-end") +
  #geom_hline(yintercept=24, linetype='dashed', color='deepskyblue1', size=1) +
  #ylim(0,200) + xlab("genome position") + ylab("Avg reads mapped per 100 sites") +
  #xlim(0,23458400) +
  #theme(axis.title.y = element_text(size=18, face="bold")) +
  #theme(axis.title.x = element_text(size=18, face="bold")) +
  #theme_minimal()

ggplot(data=subA_1000, aes(x=V2, y=V3)) +
  geom_point(size=0.1) +
  ggtitle("subA coverage, chr concatenated end-to-end") +
  geom_hline(yintercept=24, linetype='dashed', color='deepskyblue1', size=1) +
  ylim(0,150) + xlab("genome position") + ylab("Avg reads mapped per 1000 sites") +
  #xlim(0,23458400) +
  scale_x_continuous(breaks=c(0,25000000,50000000,75000000,100000000,125000000,150000000,175000000,200000000,225000000,250000000), limits=c(0,max(subA_1000$V2)))+
  theme(axis.title.y = element_text(size=18, face="bold")) +
  theme(axis.title.x = element_text(size=18, face="bold")) +
  theme_minimal()

median(subA$V3)
median(subA_1000$V3) #both ~24 <-- confirmed is 24 with full positions
#head(subA)
#x = sort(subA$V2)
#tail(subA)
#tail(x)
#sum(subA$V2 > 25000000)


subA_ = read.table("subA__100.txt", header=FALSE)
subA__1000 = read.table("subA__1000.txt", header=FALSE)
#ggplot(data=subA_, aes(x=V2, y=V3)) +
  #geom_point(size=0.1) +
  #ggtitle("subA' coverage, chr concatenated end-to-end") +
  #geom_hline(yintercept=24, linetype='dashed', color='chartreuse2', size=1) +
  #ylim(0,200) + xlab("genome position") + ylab("Avg reads mapped per 100 sites") +
  #xlim(0,23256900) +
  #theme(axis.title.y = element_text(size=18, face="bold")) +
  #theme(axis.title.x = element_text(size=18, face="bold")) +
  #theme_minimal() 

ggplot(data=subA__1000, aes(x=V2, y=V3)) +
  geom_point(size=0.1) +
  ggtitle("subA' coverage, chr concatenated end-to-end") +
  geom_hline(yintercept=24, linetype='dashed', color='chartreuse2', size=1) +
  ylim(0,150) + xlab("genome position") + ylab("Avg reads mapped per 1000 sites") +
  #xlim(0,23256900) +
  scale_x_continuous(breaks=c(0,25000000,50000000,75000000,100000000,125000000,150000000,175000000,200000000,225000000,250000000), limits=c(0,max(subA__1000$V2)))+
  theme(axis.title.y = element_text(size=18, face="bold")) +
  theme(axis.title.x = element_text(size=18, face="bold")) +
  theme_minimal() 

median(subA_$V3)
median(subA__1000$V3) #both ~24 <-- confirmed to be 24 with full positions
#tail(subA_)

subB = read.table("subB_100.txt", header=FALSE)
subB_1000 = read.table("subB_1000.txt", header=FALSE)

ggplot(data=subB, aes(x=V2, y=V3)) +
  geom_point(size=0.1) +
  ggtitle("subB coverage, chr concatenated end-to-end") +
  geom_hline(yintercept=29, linetype='dashed', color='deeppink', size=1) +
  ylim(0,200) + xlab("genome position") + ylab("Avg reads mapped per 100 sites") +
  #xlim(0,25484200) +
  theme(axis.title.y = element_text(size=18, face="bold")) +
  theme(axis.title.x = element_text(size=18, face="bold")) +
  theme_minimal()

ggplot(data=subB_1000, aes(x=V2, y=V3)) +
  geom_point(size=0.1) +
  ggtitle("subB coverage, chr concatenated end-to-end") +
  geom_hline(yintercept=29, linetype='dashed', color='deeppink', size=1) +
  ylim(0,150) + xlab("genome position") + ylab("Avg reads mapped per 1000 sites") +
  #xlim(0,25484200) +
  scale_x_continuous(breaks=c(0,25000000,50000000,75000000,100000000,125000000,150000000,175000000,200000000,225000000), limits=c(0,max(subB_1000$V2)))+
  theme(axis.title.y = element_text(size=18, face="bold")) +
  theme(axis.title.x = element_text(size=18, face="bold")) +
  theme_minimal()


max(subB_1000$V2)
median(subB$V3)
median(subB_1000$V3) #28-29 <-- confirmed to be 29 with full positions

#tail(subB)
#max(subB$V2)


######don't really care about the stuff below.... 

unanchored = read.table("unanchored_100.txt", header=FALSE)
unanchored_1000 = read.table("unanchored_1000.txt", header=FALSE)
ggplot(data=unanchored, aes(x=V2, y=V3)) +
  geom_point(size=0.1) +
  ggtitle("everything else's coverage, chr concatenated end-to-end") +
  geom_hline(yintercept=(median(unanchored$V3)), linetype='dashed', color='yellow', size=1) +
  ylim(0,200) + xlab("genome position") + ylab("Avg reads mapped per 100 sites") +
  theme(axis.title.y = element_text(size=14, face="bold")) +
  theme(axis.title.x = element_text(size=14, face="bold"))


ggplot(data=unanchored_1000, aes(x=V2, y=V3)) +
  geom_point(size=0.1) +
  ggtitle("unanchored coverage, contigs concatenated end-to-end") +
  geom_hline(yintercept=(median(unanchored_1000$V3)), linetype='dashed', color='yellow', size=1) +
  ylim(0,150) + xlab("genome position") + ylab("Avg reads mapped per 1000 sites") +
  scale_x_continuous(breaks=c(0,25000000,50000000,75000000,100000000,125000000,150000000,175000000,200000000,225000000,250000000,275000000), limits=c(0,max(unanchored_1000$V2)))+
  theme(axis.title.y = element_text(size=18, face="bold")) +
  theme(axis.title.x = element_text(size=18, face="bold")) +
  theme_minimal()

median(unanchored_1000$V3)

#boxplots for each genome quarter, side by side. I did the formatting in linux. 
all_coverage_boxplots = read.table('all_coverage_for_plotting', header=FALSE)
head(all_coverage_boxplots)

ggplot(data=all_coverage_boxplots, aes(x=V1, y=V3, color=V1)) +
  geom_boxplot() +
  ylim(0,100) +
  scale_color_manual(values=c("blue", "darkgreen","darkred","yellow3"), labels = c("subA", "subA'", "subB","unanchored"), name = "Genome subset") +
  xlab("") + ylab("Avg reads mapped per 100 sites") +
  theme(axis.title.y = element_text(size=18, face="bold")) +
  theme(axis.text.x =  element_text(size=14, face="bold")) +
  theme(axis.text.y =  element_text(size=14, face="bold"))
  
summary(subA$V3)
summary(subA_$V3)
summary(subB$V3)
summary(unanchored$V3)



