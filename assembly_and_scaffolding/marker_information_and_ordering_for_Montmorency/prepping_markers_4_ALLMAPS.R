##### Script to filter marker from a Montmorency x 25-02-29 F1 cross of 53 progeny that were mapped to our assembly. see publication: 10.1007/s11295-018-1236-2
##### The script also serves to format the data for ALLMAPS.	

setwd("/Users/Goeckeritz/Desktop/Desktop - Charity’s MacBook Pro/cherry_stuff_Charity/Genome_project/marker_ordering/redo_assembly_cuz_fruticosa_might_be_an_allo/montAv5_p99_400k/")

library(ggplot2)
library(tidyverse)
library(dplyr)
library(readxl)

#download all markers from GDR's Montx25-F1 map, even if they are duplicated in the list. 
#read in the column with only their names, and deduplicate this list. 
raw_marker_list=read.csv("raw_marker_download_from_GDR_montx25_list.txt", header=TRUE)
deduplicated_marker_list=(unique(raw_marker_list)) #there we go, 1,795 markers. We can use this list to search for the sequences in GDR
#unfortunately, not all of these markers had sequences available in GDR.. and when you search markers sometimes they are on the list multiple times >.<

blast_results = read_xlsx("mapped_markers_ABC_montAv5_p99_400k_round4.xlsx") #582 unique markers were mapped to chr1-24, allowing for 6 max hits. 
markers_to_genetic_position=read.csv("1795_markers_raw_genetic_map_download_edited.csv", header=TRUE)

#this file has duplicated markers and sequences in it for some reason... I think I probably gave it a list of the markers and kept the ones with sequences. 
summary(markers_to_genetic_position)
summary(blast_results)
#the LG is according to the peach linkage group, cuz these markers had been mapped to the peach genome. 
#now, I'd like to merge these files based on the marker name. I.e., I need to tie the marker name and location to the linkage group and genetic distance.

df1 <- left_join(blast_results, markers_to_genetic_position, by= "Marker_Name") #excellent, exactly what I was expecting. 

#which markers show multiple hits?
marker_freq=as.data.frame(table(df1$Marker_Name))
head(marker_freq)
length(which(marker_freq$Freq < 5)) #554 markers have frequency < 5
length(marker_freq$Freq) #I have 581 unique markers -- meaning 1 didn't map to the assembly at all
length(which(marker_freq$Freq==3)) #464 of those show up exactly 3x round3: 470 4: 470
length(which(marker_freq$Freq==2)) #49 of those show up exactly 2x round3: 49 4:49
length(which(marker_freq$Freq==1)) #8 round3: 8 4:8
length(which(marker_freq$Freq==4)) #33 round3: 27 4:27
#plot(marker_freq)

#filter for the markers that have under 5 hits. 
markerfreq_5 = marker_freq %>%
  filter(marker_freq$Freq < 5) %>%
  rename(Marker_Name=Var1)

head(markerfreq_5)

df2 = merge(df1, markerfreq_5, by="Marker_Name")
head(df2)

#some more filtering to get rid of low quality hits:
summary(df2$pident)
summary(df2$length)
plot(table(df2$pident))
y= 3*sd(df2$pident)
mean(df2$pident) - y #get rid of hits under 90ish% identity
yy=3*sd(df2$length)
mean(df2$length) - yy #get rid of hits that don't align a certain amount of length; even 147 seems pretty low though.let's be a little more stringent. 
boxplot(df2$length)
length(which(df2$length<160))

df3 = df2 %>%
  filter(pident >= 90) %>%
  filter(length >= 160) %>%
  filter(length <= 207)

length(unique(df3$Marker_Name)) #545 unique markers after filtering
#recalculate the frequencies - some marker mappings may have been dropped. 

final_marker_freq = as.data.frame(table(df3$Marker_Name))
markerfreq_5B = final_marker_freq %>%
  filter(final_marker_freq$Freq < 5) %>%
  rename(Marker_Name=Var1)
length(which(markerfreq_5B$Freq < 5)) #sanity check
length(which(markerfreq_5B$Freq == 1)) #29 round3: 29 round 4: 29
length(which(markerfreq_5B$Freq == 2)) #80 round3: 80 ' ' : 80
length(which(markerfreq_5B$Freq == 3)) #423 round3: 429 ' ': 429
length(which(markerfreq_5B$Freq == 4)) #13 round3: 7 ' ': 7
#let's reformat this file for ALLMAPS

df3B = subset(df3, select = -c(Freq))

df3C = left_join(df3B, markerfreq_5B, by="Marker_Name")

head(df3C)
write.csv(df3C, "w_markers_names_ABC_montAv5_p99_400k_round4B.csv")


df4 = df3 %>%
  select(scaffold_ID, sstart, LG, genetic_position) %>%
  rename("Scaffold ID" = scaffold_ID) %>%
  rename("scaffold position" = sstart) %>%
  rename("genetic position" = genetic_position)

write.csv(df4, "markers_ABC_montAv5_p99_400k_round4.csv")
#delete the first column in this file above before giving it to ALLMAPS.   

#things are easier to see in allmaps if the genome is split into 3 groups, and we just have 1 superscaffold per 
#linkage group. 


#the markers that map 3 times but have duplicated lines in the following file indicate that it is mapping more than once to the same scaffold, 
#and I'd like to know which markers map 3x, once to each scaffold. Assuming a markers isn't going to wildly map to some other chromosome group than it should be
#(I've yet to see that happen), if we can identify repeated lines, we'll identify markers mapping more than once to the same chromosome. 

aa = read_xlsx("markers_freq3_post_filter.xlsx") #429 MARKERS (1287/3), GOOD. NOW FIND UNIQUE LINES. 
bb = (unique(aa)) #FINALLY THE NUMBERS MAKE SENSE FOR THE LOVE OF GOD. 
#redo frequencies to find out which markers lost a count (I'm expecting 3). 
marker_freq_again = as.data.frame(table(bb$Marker_Name))
length(which(marker_freq_again$Freq == 3)) #ah-ha! yes, 3 lost a count. 
#FINAL MARKER NUMBER MAPPING EXACTLY ONCE TO EACH SUBGENOME: 426/545 = 78%

       