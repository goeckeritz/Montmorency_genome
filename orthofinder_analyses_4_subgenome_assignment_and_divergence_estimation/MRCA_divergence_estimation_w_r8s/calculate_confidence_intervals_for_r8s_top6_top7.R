#FYI 70 genes in single-copy orthogroups showed topology 6
#43 genes showed topology 7

setwd("/Users/Goeckeritz/Desktop/Desktop - Charity’s MacBook Pro/cherry_stuff_Charity/Genome_project/orthofinder/montAv5_p99_400k/scaffolded_genome/")

data6 = read.table("topology6_500bs_estimates_node_ages.txt", sep="\t", header=TRUE) #see most_abundant_topologies.jpg to see what topology 6 and topology 7 look like.
data7 = read.table("topology7_500bs_estimates_node_ages.txt", sep="\t", header=TRUE) 
head(data6)
summary(data6)
summary(data6$Peach_Cherry)
head(data7)
summary(data7)
summary(data7$Peach_Cherry)

# plot(data6$Malus_Prunus)  #only one date.... because we fixed the age of the node. 
plot(data6$Peach_Cherry) #looks pretty good in terms of normality
hist(data6$Peach_Cherry)
qqnorm(data6$Peach_Cherry)
plot(data6$subA___Pfruticosa) #looks pretty good in terms of normality
hist(data6$subA___Pfruticosa)
qqnorm(data6$subA___Pfruticosa) 
plot(data6$subB_Pavium)
qqnorm(data6$subB_Pavium) #looks pretty good in terms of normality
plot(data6$Pavium_Pfruticosa)
qqnorm(data6$Pavium_Pfruticosa) #looks pretty good in terms of normality
plot(data6$SubA_Pavium)
qqnorm(data6$SubA_Pavium) #looks pretty good in terms of normality

#t.test(data6$Malus_Prunus, conf.level=0.95) #yeah, expected that kind of error. We fixed the node age after all.
t.test(data6$Peach_Cherry, conf.level=0.95) #don't care about p values, just interested in the conf. interval of the mean
t.test(data6$Pavium_Pfruticosa, conf.level=0.95)
t.test(data6$subA___Pfruticosa, conf.level=0.95)
t.test(data6$subB_Pavium, conf.level=0.95)
t.test(data6$SubA_Pavium, conf.level=0.95)
#damn these are tight intervals

# plot(data7$Malus_Prunus)  #only one date.... because we fixed the age of the node. 
plot(data7$Peach_Cherry) #looks pretty good in terms of normality
hist(data7$Peach_Cherry)
qqnorm(data7$Peach_Cherry)
plot(data7$SubA___fruticosa) #looks pretty good in terms of normality
hist(data7$SubA___fruticosa)
qqnorm(data7$SubA___fruticosa) 
plot(data7$SubB_Pavium)
qqnorm(data7$SubB_Pavium) #looks pretty good in terms of normality
plot(data7$Pavium_Pfruticosa)
qqnorm(data7$Pavium_Pfruticosa) #looks pretty good in terms of normality
plot(data7$SubA_Pfruticosa)
qqnorm(data7$SubA_Pfruticosa)

#t.test(data7$Malus_Prunus, conf.level=0.95) #yeah, expected that kind of error. We fixed the node age after all.
t.test(data7$Peach_Cherry, conf.level=0.95) #don't care about p values, just interested in the conf. interval of the mean
t.test(data7$Pavium_Pfruticosa, conf.level=0.95)
t.test(data7$SubA___fruticosa, conf.level=0.95)
t.test(data7$SubB_Pavium, conf.level=0.95)
t.test(data7$SubA_Pfruticosa, conf.level=0.95)

#topology6:
#Malus_Prunus 95 mya (fixed)
#Peach_Cherry [15.21210 - 15.25514] #constrained to be at least 10 mya
#Pavium_Pfruticosa [11.27077 - 11.30659] (Pfruticosa subgenome 1(?))
#SubA___Pfruticosa [4.484664 - 4.509096]
#SubA_Pavium [8.673093 - 8.707507]
#SubB_Pavium [1.718276 - 1.734764]

#topology7:
#Malus_Prunus 95 mya (fixed)
#Peach_Cherry [15.46559 - 15.51625] #constrained to be at least 10 mya
#Pavium_Pfruticosa [8.76769 - 8.80931] (Pfruticosa subgenome 2(?))
#SubA___Pfruticosa [11.00695 - 11.05385]
#SubA_Pfruticosa [1.607956 - 1.629204]
#SubB_Pavium [2.051037 - 2.074443]

