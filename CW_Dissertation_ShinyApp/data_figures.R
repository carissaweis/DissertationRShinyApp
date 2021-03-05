library(ggplot2)
library(reshape)
library(tidyr)
library(dplyr)
library(sqldf)
library(lme4)
library(plotly)
library(ggiraph)
library(readxl)

# Static Functional Connectivity Analysis  
##Color Correlation Matrices for Static FC

#Load PTSD group and TEC group static FC matrix
##MAKE SURE THAT IN THE COLUMN NAMES FOR EACH OF THE BELOW CSV FILES THAT SINCE THE LAST COMPONENT IS, FOR EXAMPLE, C51 THAT ALL THE PRIOR COLUMNS ALSO HAVE 2 DIGITS IN THEIR NAMING CONVENTIONS, I.E. C01, C02, C03, ETC. IF NOT, GGPLOT WILL COMPLETELY SCREW UP THE ORDER IN WHICH IT PLOTS YOUR COLUMNS AND THE CLEAN BLACK DIAGONAL LINE YOU'D EXPECT IN THE COLORED MATRIX WILL BE JUMBLED. THAT AT LEAST WILL TELL YOU THAT YOU DIDN'T DO THIS STEP PRIOR TO LOADING INTO R.
GROUP1_STATIC<-read.csv("PTSD_MEAN_ALL_STATIC_R.csv", header=TRUE)
#Replace the diagonal values of this matrix as "NAs" so that in the colored matrix they appear as black squares


# ORDER BY COG DOMAINS
# ORDER DETERMINED FROM Analysis/ROUND_1_INFOMAX/component_selection.xlsx "INFOMAX_cog_domains" sheet. "Ordered_Comp" indicates desired order of components after grouping. ColNum indicates the original unsorted column numbers (not component numbers because the outputs from MATLAB don't number columns according to the actual component number just based on index of component in the list of component numbers)
COMP_ORDER<-c(11, 22, 26, 35, 36, 37, 40, 42, 3, 14, 15, 18, 23, 27, 34, 38, 41, 1, 12, 28, 29, 30, 31 ,32 ,39, 2, 6, 8, 13, 4, 5, 17, 7, 9, 10, 16, 19, 20, 21 ,24, 25, 33)


GROUP1_STATIC<-GROUP1_STATIC[COMP_ORDER, COMP_ORDER]
diag(GROUP1_STATIC)=NA
COLNAMES<-colnames(GROUP1_STATIC)
#GROUP1_STATIC$COMP_GROUP=COMP_GROUP

GROUP2_STATIC<-read.csv("TEC_MEAN_ALL_STATIC_R.csv", header=TRUE)
GROUP2_STATIC<-GROUP2_STATIC[COMP_ORDER, COMP_ORDER]
diag(GROUP2_STATIC)=NA




#Melt our matrices to expand our component numbers as rows rather than columns. Basically rearranges our matrix so that it isn't a matrix anymore but rather an array of the pairwise connectivity values. So ggplot can plot appropriately.
melted_GROUP1_STATIC <- melt(as.matrix(GROUP1_STATIC))
melted_GROUP2_STATIC <- melt(as.matrix(GROUP2_STATIC))

melted_GROUP1_STATIC$X1<-as.factor(melted_GROUP1_STATIC$X1)
melted_GROUP2_STATIC$X1<-as.factor(melted_GROUP2_STATIC$X1)


COMP_GROUP1<-c(rep("Cerebellar", 42), rep("CogControl", 42*7), rep("DMN", 42*9), rep("LangAud", 42*8), rep("Sensorimotor", 42*4), rep("Subcortical", 42*3), rep("Visual", 42*10))
COMP_GROUP2<-rep(c("Cerebellar", rep("CogControl", 7), rep("DMN", 9), rep("LangAud", 8), rep("Sensorimotor", 4), rep("Subcortical", 3), rep("Visual", 10)), 42)
#COMP_GROUP2<-c(rep(1, 42), rep(2, 42*7), rep(3, 42*9), rep(4, 42*8), rep(5, 42*4), rep(6, 42*3), rep(7, 42*10))

melted_GROUP1_STATIC$COMP_GROUP1<-COMP_GROUP1
melted_GROUP1_STATIC$COMP_GROUP2<-COMP_GROUP2

#Use ggplot to create geom_tile figure (matrix), X1 is essentially the component numbers, as is X2 (but in the pairwise fashion), value is then the correlation coefficient between the paired correlation of X1 and X2 (now just rearranged). Can change how many different colors appear in the matrix using the scale_fill_gradientn(colours=rainbow(#)) this option is fun to play around with to best display your range of values in the matrix. Do this plotting for both DX groups separately.


change_comp_labels<-c("C11" = "11", "C22" = "22", "C26" = "26", "C35" = "35", "C36" = "36", "C37" = "37", "C40" = "40", "C42" = "42", "C03" = "3", "C14" = "14", "C15" = "15", "C18" = "18", "C23" = "23", "C27" = "27", "C34" = "34", "C38" = "38", "C41" = "41", "C01" = "1", "C12" = "12", "C28" = "28", "C29" = "29", "C30" = "30", "C31" = "31", "C32" = "32", "C39" = "39", "C02" = "2", "C06" = "6", "C08" = "8", "C13" = "13", "C04" = "4", "C05" = "5", "C17" = "17", "C07" = "7", "C09" = "9", "C10" = "10", "C16" = "16", "C19" = "19", "C20" = "20", "C21" = "21", "C24" = "24", "C25" = "25", "C33" = "33")



corrmat_GROUP1_Savg<-ggplot(data = melted_GROUP1_STATIC, aes(x=X2, y=X1)) + 
  geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value))+ 
  scale_fill_gradientn(colours=rev(rainbow(5)), na.value="#ffffff", 
                       guide=guide_colourbar(barheight=8, label.position="left", 
                                             title="Correlation"), limit = c(0,0.8), 
                       space = "Lab") + 
  theme_classic() + 
  labs(title="PTSD", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
  plot.margin = unit(c(.2,0,0,0), "lines"), legend.position="left",
  legend.margin=margin(0,-15,0,0), legend.box.margin=margin(0,-20,0,0),
  axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold"), 
  legend.title=element_text(size=8, face="bold"), legend.text=element_text(size=6)) + 
  scale_x_discrete(limits=unique(melted_GROUP1_STATIC$X2), labels=change_comp_labels) +
  scale_y_discrete(limits=unique(melted_GROUP1_STATIC$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') +
  annotate(geom = "text", x = 37, y=-2, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 31-0.5, y=-2, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 27-0.5, y=-2, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 21, y=-2, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 12, y=-2, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 4, y=-2, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 0.5, y=-2, label = "CB", hjust = "left", size=4)


#tooltip = c("X2", "X1", "value"), 
#ggplotly(corrmat_GROUP1_Savg, tooltip="value") %>% config(displayModeBar= FALSE, edits=list(annotationPosition= TRUE)) %>% hide_guides()
#layout(legend = list(orientation="v", x=0, y=0))



corrmat_GROUP2_Savg<-ggplot(data = melted_GROUP2_STATIC, aes(x=X2, y=X1, fill=value)) + 
  geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value)) + 
  scale_fill_gradientn(colours=rev(rainbow(5)), na.value="#ffffff", limit = c(0,0.8), 
                       space = "Lab", name="Correlation") + 
  theme_classic() + 
  labs(title="Control", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
  plot.margin = unit(c(.2,2.2,0,0), "lines"), legend.position="none", 
  axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold")) + 
  scale_x_discrete(limits=unique(melted_GROUP2_STATIC$X2), labels=change_comp_labels) +
  scale_y_discrete(limits=unique(melted_GROUP2_STATIC$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) +
  coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') + 
  annotate(geom = "text", x = 43, y = 37, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 43, y = 31, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 28-0.5, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 22-0.5, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 13, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 5, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 1, label = "CB", hjust = "left", size=4) + 
  annotate(geom = "text", x = 37, y=-2, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 31-0.5, y=-2, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 27-0.5, y=-2, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 21, y=-2, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 12, y=-2, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 4, y=-2, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 0.5, y=-2, label = "CB", hjust = "left", size=4)


#ggiraph(ggobj=corrmat_GROUP1_Savg, hover_css = "fill:red;")
#ggiraph(ggobj=corrmat_GROUP2_Savg, hover_css = "fill:red;")





group_static_diff<-cbind(melted_GROUP1_STATIC$X1, melted_GROUP1_STATIC$X2, (melted_GROUP1_STATIC$value-melted_GROUP2_STATIC$value))
colnames(group_static_diff)<-c("X1", "X2", "value")
group_static_diff<-as.data.frame(group_static_diff)
group_static_diff$X1<-as.factor(group_static_diff$X1)
group_static_diff$X2<-as.factor(group_static_diff$X2)




sFC_DIFF<-
  ggplot(data = group_static_diff, aes(x=X2, y=X1)) + 
  geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value)) +
  scale_fill_gradient2(low="#0a4dff", mid="#ffffff", high="#ff0a0a", midpoint=0, guide=guide_colourbar(barheight=15, label.position="left", title="Correlation\n (PTSD - Control)"), aesthetics="fill", na.value="#ffffff", limit = c(-0.1,0.1), space = "Lab") + 
  theme_classic() + 
  labs(title="Difference in Static FC \n(PTSD - Control)", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
        plot.margin = unit(c(.2,2.2,0,0), "lines"), legend.position="left",
        legend.margin=margin(0,-15,0,0), legend.box.margin=margin(0,-20,0,0),
        axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=8, face="bold"), legend.text=element_text(size=6)) + 
  scale_x_discrete(limits=unique(group_static_diff$X2), labels=change_comp_labels) +
  scale_y_discrete(limits=unique(group_static_diff$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') + 
  annotate(geom = "text", x = 43, y = 37, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 43, y = 31, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 28-0.5, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 22-0.5, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 13, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 5, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 1, label = "CB", hjust = "left", size=4) + 
  annotate(geom = "text", x = 37, y = -2, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 31-0.5, y = -2, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 27, y = -2, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 21, y = -2, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 12, y = -2, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 4, y = -2, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 0.5, y = -2, label = "CB", hjust = "left", size=4)

  #ggiraph(ggobj=sFC_DIFF, hover_css = "fill:red;")



######
#####
####
###
##
# SFC STATS RESULTS
##
###
####
#####
###### 

#
#sFC_ttest_n1049_ggplot_df<-write.csv(melted_signlog_ordered, "~/OneDrive - UWM/Larson Lab/Dissertation/Analysis/ROUND_1_INFOMAX/sFC_ttest_n1049_ggplot_df.csv", col.names=TRUE)
#
sFC_ttest_n1049_ggplot_df<-read.csv("sFC_ttest_n1049_ggplot_df.csv", header=TRUE)
sFC_ttest_n1049_ggplot_df<-sFC_ttest_n1049_ggplot_df[,-1]
sFC_ttest_n1049_ggplot_df$X1<-as.factor(sFC_ttest_n1049_ggplot_df$X1)
change_comp_labels_Xs<-c("X11" = "11", "X22" = "22", "X26" = "26", "X35" = "35", "X36" = "36", "X37" = "37", "X40" = "40", "X42" = "42", "X3" = "3", "X14" = "14", "X15" = "15", "X18" = "18", "X23" = "23", "X27" = "27", "X34" = "34", "X38" = "38", "X41" = "41", "X1" = "1", "X12" = "12", "X28" = "28", "X29" = "29", "X30" = "30", "X31" = "31", "X32" = "32", "X39" = "39", "X2" = "2", "X6" = "6", "X8" = "8", "X13" = "13", "X4" = "4", "X5" = "5", "X17" = "17", "X7" = "7", "X9" = "9", "X10" = "10", "X16" = "16", "X19" = "19", "X20" = "20", "X21" = "21", "X24" = "24", "X25" = "25", "X33" = "33")


sFC_stats_n1049<-
  ggplot(data = sFC_ttest_n1049_ggplot_df, aes(x=X2, y=X1)) + 
    geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value)) + 
  scale_fill_gradientn(colours=rev(rainbow(5)), na.value="#ffffff", 
                       guide=guide_colourbar(barheight=15, label.position="left", title="-sign(t)log(p)"), 
                       limit = c(-20,6), space = "Lab") + 
  theme_classic() + 
  labs(title="Static Functional Connectivity\n PTSD-Control (no covariates)", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
        plot.margin = unit(c(.2,2.2,0,0), "lines"), legend.position="left",
        legend.margin=margin(0,-10,0,0), legend.box.margin=margin(0,-20,0,0),
        axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=8, face="bold"), legend.text=element_text(size=6)) + 
  scale_x_discrete(limits=unique(sFC_ttest_n1049_ggplot_df$X2), labels=change_comp_labels_Xs) +
  scale_y_discrete(limits=unique(sFC_ttest_n1049_ggplot_df$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') + 
  annotate(geom = "text", x = 43, y = 37, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 43, y = 31, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 28-0.5, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 22-0.5, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 13, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 5, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 1, label = "CB", hjust = "left", size=4) + 
  annotate(geom = "text", x = 37, y = -2, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 31-0.5, y = -2, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 27, y = -2, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 21, y = -2, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 12, y = -2, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 4, y = -2, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 0.5, y = -2, label = "CB", hjust = "left", size=4) 
 # geom_text(label=sFC_ttest_n1049_ggplot_df$SigStar, size=5, color="black", vjust="0")
  
  #ggiraph(ggobj=sFC_stats_n1049, hover_css = "fill:red;")
  

######
#####
####
###
##
# SFC STATS RESULTS (REDUCED SAMPLES)
##
###
####
##### 
###### 


##
#sFC_ttest_n442_ggplot_df<-write.csv(melted_signlog_anova_allcovars_ordered, "~/OneDrive - UWM/Larson Lab/Dissertation/Analysis/ROUND_1_INFOMAX/sFC_ttest_n442_ggplot_df.csv", col.names=TRUE)
#
sFC_ttest_n442_ggplot_df<-read.csv("sFC_ttest_n442_ggplot_df.csv", header=TRUE)
sFC_ttest_n442_ggplot_df<-sFC_ttest_n442_ggplot_df[,-1]

sFC_ttest_n442_ggplot_df$X1<-as.factor(sFC_ttest_n442_ggplot_df$X1)
#
#sFC_ttest_n779_ggplot_df<-write.csv(melted_signlog_anova_allcovars_minusCT_ordered, "~/OneDrive - UWM/Larson Lab/Dissertation/Analysis/ROUND_1_INFOMAX/sFC_ttest_n779_ggplot_df.csv", col.names=TRUE)
#
sFC_ttest_n779_ggplot_df<-read.csv("sFC_ttest_n779_ggplot_df.csv", header=TRUE)
sFC_ttest_n779_ggplot_df<-sFC_ttest_n779_ggplot_df[,-1]

sFC_ttest_n779_ggplot_df$X1<-as.factor(sFC_ttest_n779_ggplot_df$X1)

change_comp_labels_Xs<-c("X11" = "11", "X22" = "22", "X26" = "26", "X35" = "35", "X36" = "36", "X37" = "37", "X40" = "40", "X42" = "42", "X3" = "3", "X14" = "14", "X15" = "15", "X18" = "18", "X23" = "23", "X27" = "27", "X34" = "34", "X38" = "38", "X41" = "41", "X1" = "1", "X12" = "12", "X28" = "28", "X29" = "29", "X30" = "30", "X31" = "31", "X32" = "32", "X39" = "39", "X2" = "2", "X6" = "6", "X8" = "8", "X13" = "13", "X4" = "4", "X5" = "5", "X17" = "17", "X7" = "7", "X9" = "9", "X10" = "10", "X16" = "16", "X19" = "19", "X20" = "20", "X21" = "21", "X24" = "24", "X25" = "25", "X33" = "33")

sFC_stats_n442<-
  ggplot(data = sFC_ttest_n442_ggplot_df, aes(x=X2, y=X1)) + 
  geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value)) + 
  scale_fill_gradientn(colours=rev(rainbow(5)), na.value="#ffffff", guide=guide_colourbar(barheight=15, label.position="left", title="-sign(t)log(p)"), limit = c(-17,10), space = "Lab") + 
  theme_classic() + 
  labs(title="Static Functional Connectivity PTSD-Control Group Comparisons\n ANCOVA with Age/Sex/Dep Dx/Childhood Trauma (n=442)", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
        plot.margin = unit(c(.2,2.2,0,0), "lines"), legend.position="left",
        legend.margin=margin(0,-10,0,0), legend.box.margin=margin(0,-20,0,0),
        axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=8, face="bold"), legend.text=element_text(size=6)) + 
  scale_x_discrete(limits=unique(sFC_ttest_n442_ggplot_df$X2), labels=change_comp_labels_Xs) +
  scale_y_discrete(limits=unique(sFC_ttest_n442_ggplot_df$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
    coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') + 
    annotate(geom = "text", x = 43, y = 37, label = "VIS",hjust="left", size=4) + 
    annotate(geom = "text", x = 43, y = 31, label = "SC", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 28-0.5, label = "SM", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 22-0.5, label = "L/A", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 13, label = "DMN", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 5, label = "COG", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 1, label = "CB", hjust = "left", size=4) + 
    annotate(geom = "text", x = 37, y = -2, label = "VIS",hjust="left", size=4) + 
    annotate(geom = "text", x = 31-0.5, y = -2, label = "SC", hjust = "left", size=4) + 
    annotate(geom = "text", x = 27, y = -2, label = "SM", hjust = "left", size=4) + 
    annotate(geom = "text", x = 21, y = -2, label = "L/A", hjust = "left", size=4) + 
    annotate(geom = "text", x = 12, y = -2, label = "DMN", hjust = "left", size=4) + 
    annotate(geom = "text", x = 4, y = -2, label = "COG", hjust = "left", size=4) + 
    annotate(geom = "text", x = 0.5, y = -2, label = "CB", hjust = "left", size=4) 
#+  geom_text(label=sFC_ttest_n442_ggplot_df$SigStar, size=5, color="black", vjust="0")

#ggiraph(ggobj=sFC_stats_n442, hover_css = "fill:red;")

sFC_stats_n779<-
  ggplot(data = sFC_ttest_n779_ggplot_df, aes(x=X2, y=X1)) + 
  geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value)) + 
  scale_fill_gradientn(colours=rev(rainbow(5)), na.value="#ffffff", guide=guide_colourbar(barheight=15, label.position="left", title="-sign(t)log(p)"), limit = c(-17,10), space = "Lab") + 
  theme_classic() + 
  labs(title="Static Functional Connectivity PTSD-Control Group Comparisons\n ANCOVA with Age/Sex/Dep Dx (n=779)", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
        plot.margin = unit(c(.2,2.2,0,0), "lines"), legend.position="left",
        legend.margin=margin(0,-10,0,0), legend.box.margin=margin(0,-20,0,0),
        axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=8, face="bold"), legend.text=element_text(size=6)) + 
  scale_x_discrete(limits=unique(sFC_ttest_n779_ggplot_df$X2), labels=change_comp_labels_Xs) +
  scale_y_discrete(limits=unique(sFC_ttest_n779_ggplot_df$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
    coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') + 
    annotate(geom = "text", x = 43, y = 37, label = "VIS",hjust="left", size=4) + 
    annotate(geom = "text", x = 43, y = 31, label = "SC", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 28-0.5, label = "SM", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 22-0.5, label = "L/A", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 13, label = "DMN", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 5, label = "COG", hjust = "left", size=4) + 
    annotate(geom = "text", x = 43, y = 1, label = "CB", hjust = "left", size=4) + 
    annotate(geom = "text", x = 37, y = -2, label = "VIS",hjust="left", size=4) + 
    annotate(geom = "text", x = 31-0.5, y = -2, label = "SC", hjust = "left", size=4) + 
    annotate(geom = "text", x = 27, y = -2, label = "SM", hjust = "left", size=4) + 
    annotate(geom = "text", x = 21, y = -2, label = "L/A", hjust = "left", size=4) + 
    annotate(geom = "text", x = 12, y = -2, label = "DMN", hjust = "left", size=4) + 
    annotate(geom = "text", x = 4, y = -2, label = "COG", hjust = "left", size=4) + 
    annotate(geom = "text", x = 0.5, y = -2, label = "CB", hjust = "left", size=4) 
#+  geom_text(label=sFC_ttest_n779_ggplot_df$SigStar, size=5, color="black", vjust="0")

#ggiraph(ggobj=sFC_stats_n779, hover_css = "fill:red;")


domain_table<-read.csv("domain_table.csv", header=TRUE)
CB_tab<-subset(domain_table, Domain=="Cerebellum")[,-1]
COG_tab<-subset(domain_table, Domain=="Cognitive Control")[,-1]
DMN_tab<-subset(domain_table, Domain=="Default Mode")[,-1]
LA_tab<-subset(domain_table, Domain=="Language/Audition")[,-1]
SM_tab<-subset(domain_table, Domain=="Sensorimotor")[,-1]
SC_tab<-subset(domain_table, Domain=="Subcortical")[,-1]
VIS_tab<-subset(domain_table, Domain=="Visual")[,-1]


######
#####
####
###
##
# DFC PLOTS
##
###
####
##### 
######

##RAN INTO SOME CRAZY PLOTTING ISSUE THAT I'M NOT EVEN SURE HOW I CAUGHT THIS.
##BUT MAKE SURE THAT IN THE COLUMN NAMES FOR EACH OF THE BELOW CSV FILES THAT SINCE THE LAST WINDOW IS, FOR EXAMPLE, GE219 THAT ALL THE PRIOR COLUMNS ALSO HAVE 3 DIGITS IN THEIR NAMING CONVENTIONS, I.E. GE001, GE002, GE003, ETC. IF NOT, GGPLOT WILL COMPLETELY SCREW UP THE ORDER IN WHICH IT PLOTS YOUR COLUMNS AND YOUR PLOTS WILL LOOK CRAZY.

GROUP1_global_eff <- as.data.frame(read.csv("PTSD_W_global_efficiency.csv", header=TRUE))
GROUP1_local_eff <- as.data.frame(read.csv("PTSD_W_local_efficiency.csv", header=TRUE))
GROUP1_clustercoef <- as.data.frame(read.csv("PTSD_W_clustercoef_output.csv", header=TRUE))
GROUP1_connectivity_strength <- as.data.frame(read.csv("PTSD_W_connect_strength.csv", header=TRUE))
GROUP1_path_length <- as.data.frame(read.csv("PTSD_W_char_path.csv", header=TRUE))

GROUP1_GE_mean_W<-colMeans(GROUP1_global_eff)
GROUP1_LE_mean_W<-colMeans(GROUP1_local_eff)
GROUP1_CC_mean_W<-colMeans(GROUP1_clustercoef)
GROUP1_CS_mean_W<-colMeans(GROUP1_connectivity_strength)
GROUP1_PL_mean_W<-colMeans(GROUP1_path_length)



GROUP2_global_eff <- as.data.frame(read.csv("TEC_W_global_efficiency.csv", header=TRUE))
GROUP2_local_eff <- as.data.frame(read.csv("TEC_W_local_efficiency.csv", header=TRUE))
GROUP2_clustercoef <- as.data.frame(read.csv("TEC_W_clustercoef_output.csv", header=TRUE))
GROUP2_connectivity_strength <- as.data.frame(read.csv("TEC_W_connect_strength.csv", header=TRUE))
GROUP2_path_length <- as.data.frame(read.csv("TEC_W_char_path.csv", header=TRUE))


#Calculate the column means for every column in our graph theory matrices
GROUP2_GE_mean_W<-colMeans(GROUP2_global_eff)
GROUP2_LE_mean_W<-colMeans(GROUP2_local_eff)
GROUP2_CC_mean_W<-colMeans(GROUP2_clustercoef)
GROUP2_CS_mean_W<-colMeans(GROUP2_connectivity_strength)
GROUP2_PL_mean_W<-colMeans(GROUP2_path_length)

#Concatenate the HIGH and LOW graph theory matrices together. The only way this works is if the columns of both of the input matrices have the same names (so it knows how to combine these datasets appropriately)
GE_mean<-rbind(GROUP1_GE_mean_W, GROUP2_GE_mean_W)
row.names(GE_mean)<-c("PTSD", "Control")
LE_mean<-rbind(GROUP1_LE_mean_W, GROUP2_LE_mean_W)
row.names(LE_mean)<-c("PTSD", "Control")
CC_mean<-rbind(GROUP1_CC_mean_W, GROUP2_CC_mean_W)
row.names(CC_mean)<-c("PTSD", "Control")
CS_mean<-rbind(GROUP1_CS_mean_W, GROUP2_CS_mean_W)
row.names(CS_mean)<-c("PTSD", "Control")
PL_mean<-rbind(GROUP1_PL_mean_W, GROUP2_PL_mean_W)
row.names(PL_mean)<-c("PTSD", "Control")

#Reshape the now concatenated datasets into long format so that we can use ggplot to plot the time series nicely.
#We'll reshape the data according to a dimension we've designated as "time" using the column names. Be sure to exclude the first column as that's just the names of our groups and we don't need those in long format.
reshape_GE_mean<-melt(data=GE_mean, id=c("time"), measure=c(colnames(GE_mean[,2:ncol(GE_mean)])))
reshape_LE_mean<-melt(data=LE_mean, id=c("time"), measure=c(colnames(LE_mean[,2:ncol(LE_mean)])))
reshape_CC_mean<-melt(data=CC_mean, id=c("time"), measure=c(colnames(CC_mean[,2:ncol(CC_mean)])))
reshape_CS_mean<-melt(data=CS_mean, id=c("time"), measure=c(colnames(CS_mean[,2:ncol(CS_mean)])))
reshape_PL_mean<-melt(data=PL_mean, id=c("time"), measure=c(colnames(PL_mean[,2:ncol(PL_mean)])))

reshape_GE_mean$X1 <- factor(reshape_GE_mean$X1, levels = c("PTSD", "Control"), labels = c("PTSD", "Control"))
reshape_LE_mean$X1 <- factor(reshape_LE_mean$X1, levels = c("PTSD", "Control"), labels = c("PTSD", "Control"))
reshape_CC_mean$X1 <- factor(reshape_CC_mean$X1, levels = c("PTSD", "Control"), labels = c("PTSD", "Control"))
reshape_CS_mean$X1 <- factor(reshape_CS_mean$X1, levels = c("PTSD", "Control"), labels = c("PTSD", "Control"))
reshape_PL_mean$X1 <- factor(reshape_PL_mean$X1, levels = c("PTSD", "Control"), labels = c("PTSD", "Control"))
#The result of our melting command should result in a dataframe that now has columns of our windows (rather than rows) and for each of our groups, with the corresponding graph theory metric. This way ggplot can plot our rows as separate observations rather than plot columns (which it can't do).

#Plot our graph theory metrics over time by group using our melted data sets. X2 refers to the time window index, value refers to the graph theory value, and X1 are the names of our 2 groups of interest.
GE_plot_W<-ggplot(data=reshape_GE_mean, aes(x=X2, y=value, group=X1, color=X1)) + geom_line(size=1.2) + theme_light() + theme(legend.title=element_blank()) + labs(title="Global Efficiency", x="Time Window", y="") + theme(plot.title = element_text(hjust = 0.5, size=22), plot.margin = unit(c(1,5,5,1), "lines"), legend.position="right", axis.text = element_text(size = 20), axis.title=element_text(size=20), legend.title=element_blank(), legend.text=element_text(size=20)) + scale_x_discrete(breaks=c("W001","W050","W100", "W150", "W200"), labels=c("1","50","100", "150", "200"))
LE_plot_W<-ggplot(data=reshape_LE_mean, aes(x=X2, y=value, group=X1, color=X1)) + geom_line(size=1.2) + theme_light() + theme(legend.title=element_blank()) + labs(title="Local Efficiency", x="Time Window", y="") + theme(plot.title = element_text(hjust = 0.5, size=22), plot.margin = unit(c(1,5,5,1), "lines"), legend.position="right", axis.text = element_text(size = 20), axis.title=element_text(size=20), legend.title=element_blank(), legend.text=element_text(size=20)) + scale_x_discrete(breaks=c("W001","W050","W100", "W150", "W200"), labels=c("1","50","100", "150", "200"))
CC_plot_W<-ggplot(data=reshape_CC_mean, aes(x=X2, y=value, group=X1, color=X1)) + geom_line(size=1.2) + theme_light() + theme(legend.title=element_blank()) + labs(title="Clustering Coefficient", x="Time Window", y="") + theme(plot.title = element_text(hjust = 0.5, size=22), plot.margin = unit(c(1,5,5,1), "lines"), legend.position="right", axis.text = element_text(size = 20), axis.title=element_text(size=20), legend.title=element_blank(), legend.text=element_text(size=20)) + scale_x_discrete(breaks=c("W001","W050","W100", "W150", "W200"), labels=c("1","50","100", "150", "200"))
CS_plot_W<-ggplot(data=reshape_CS_mean, aes(x=X2, y=value, group=X1, color=X1)) + geom_line(size=1.2) + theme_light() + theme(legend.title=element_blank()) + labs(title="Connectivity Strength", x="Time Window", y="") + theme(plot.title = element_text(hjust = 0.5, size=22), plot.margin = unit(c(1,5,5,1), "lines"), legend.position="right", axis.text = element_text(size = 20), axis.title=element_text(size=20), legend.title=element_blank(), legend.text=element_text(size=20)) + scale_x_discrete(breaks=c("W001","W050","W100", "W150", "W200"), labels=c("1","50","100", "150", "200"))
PL_plot_W<-ggplot(data=reshape_PL_mean, aes(x=X2, y=value, group=X1, color=X1)) + geom_line(size=1.2) + theme_light() + theme(legend.title=element_blank()) + labs(title="Characteristic Path Length", x="Time Window", y="") + theme(plot.title = element_text(hjust = 0.5, size=22), plot.margin = unit(c(1,5,5,1), "lines"), legend.position="right", axis.text = element_text(size = 20), axis.title=element_text(size=20), legend.title=element_blank(), legend.text=element_text(size=20)) + scale_x_discrete(breaks=c("W001","W050","W100", "W150", "W200"), labels=c("1","50","100", "150", "200"))

######
#####
####
###
##
# DFC TABLES
##
###
####
##### 
######


dFC_table_fullsample <- read_excel("dFC_tables_allsamples.xlsx", sheet = "fullsample_1049")
dFC_table_fullsample$p<-c("<0.001*", "<0.001*", "0.812", "0.073", "<0.001*", "<0.001*", "0.875", "0.098", "<0.001*", "<0.001*", 
                          "0.874", "0.097", "<0.001*", "<0.001*", "0.942", "0.085", "<0.001*", "<0.001*", "0.523", "0.065")


dFC_table_allcovars <- read_excel("dFC_tables_allsamples.xlsx", sheet = "allcovars_442")
dFC_table_allcovars$p<-c("<0.001*", "0.334", "0.057", "0.459", "0.219", "<0.001*", "0.203", "0.064",
                         "<0.001*", "0.437", "0.074", "0.388", "0.181", "<0.001*", "0.169", "0.077",
                         "<0.001*", "0.438", "0.074", "0.388", "0.181", "<0.001*", "0.168", "0.077",
                         "<0.001*", "0.378", "0.064", "0.429", "0.207", "<0.001*", "0.185", "0.07",
                         "<0.001*", "0.614", "0.068", "0.389", "0.164", "<0.001*", "0.107", "0.082")


dFC_table_somecovars <- read_excel("dFC_tables_allsamples.xlsx", sheet = "somecovars_779")
dFC_table_somecovars$P<-c("<0.001*", "0.289", "<0.001*", "0.929", "<0.001*", "0.687", "0.178",
                          "<0.001*", "0.275", "<0.001*", "0.88", "<0.001*", "0.503", "0.201",
                          "<0.001*", "0.276", "<0.001*", "0.88", "<0.001*", "0.502", "0.201",
                          "<0.001*", "0.289", "<0.001*", "0.909", "<0.001*", "0.607", "0.191",
                          "<0.001*", "0.447", "<0.001*", "0.75", "<0.001*", "0.31", "0.122")


######
#####
####
###
##
# INDIV CS FIGURES
##
###
####
##### 
######
subs_modules <- read.csv("CS_indiv_counts.csv")
scanhalves <- read.csv("scanhalves_df.csv")
CS_indiv_counts_props<-ggplot(subs_modules, aes(Num_Indiv_Modules)) + 
  geom_bar(aes(y=(..count../sum(..count..)), fill=Group), position="dodge") + 
  scale_y_continuous(labels=scales::percent) + theme_classic() + 
  labs(title="Counts of Individual-Level Connectivity States by Group (N=1,049)", x="Number of Connectivity States", y="Relative Proportion of Subjects") + 
  theme(plot.title=element_text(hjust=0.5, size=18, face="bold"), 
        axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=16, face="bold"), legend.text=element_text(size=14)) 

CS_indiv_counts_props_halves<-ggplot(scanhalves, aes(x=Num_Indiv_Modules)) + 
  geom_bar(aes(y=(..count../sum(..count..)), fill=Group), position="dodge") + 
  scale_y_continuous(labels=scales::percent) + facet_wrap(~ScanHalf) + theme_classic() + 
  labs(title="Counts of Individual-Level Connectivity States\n by Scan Halves and Group (N=1,049)", 
       x="Number of Connectivity States", y="Relative Proportion of Subjects") + 
  theme(plot.title=element_text(hjust=0.5, size=18, face="bold"), axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"), legend.title=element_text(size=16, face="bold"), 
        legend.text=element_text(size=16), strip.text.x=element_text(size=16), panel.background=element_rect(fill=NA, color="black"))

######
#####
####
###
##
# GROUP CS FIGURES
##
###
####
##### 
######
dwell_groups <- read.csv("dwell_groups_wholescan.csv")
CS_groups <- read.csv("transition_groups_wholescan.csv")
transitions_means_whole<-read.csv("transitions_means_whole.csv")

CS_group_dwell_plot<-ggplot(dwell_groups, aes(x=CS_num, y=Mean, fill=Group)) + 
  geom_bar(stat="identity", position=position_dodge()) + 
  geom_errorbar(aes(ymin=Mean-SD, ymax=Mean+SD), width=.1, size=1, position=position_dodge(.9)) + 
  theme_classic() + labs(title="Average Dwell Time", x="Group Connectivity State", y="Average Dwell Time (TRs)") + 
  theme(plot.title=element_text(hjust=0.5, size=18, face="bold"), 
        axis.text=element_text(size=16),
        axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=14, face="bold"), 
        legend.text=element_text(size=12))

CS_group_transition_counts_plot<-ggplot(CS_groups, aes(x=Transition_Tally_2cluster)) + 
  geom_histogram(aes(y=(..count../sum(..count..)), colour=Group, fill=Group), position="identity", binwidth=1, alpha=0.7) + 
  geom_vline(data=transitions_means_whole, aes(xintercept=m, colour=Group), linetype="dashed", size=1) + 
  theme_classic() + labs(title="Transitions", x="Transitions", y="Relative Proportion of Subjects") + 
  theme(plot.title=element_text(hjust=0.5, size=18, face="bold"), 
        axis.text=element_text(size=16),
        axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=14, face="bold"), 
        legend.text=element_text(size=12))

## BY HALVES
dwell_groups_halves <- read.csv("dwell_groups_halves.csv")
transitions_means<- read.csv("transitions_means.csv")
CS_group_dwell_halves_plot<-ggplot(dwell_groups_halves, aes(x=CS_num, y=Mean, fill=Group)) + 
  geom_bar(stat="identity", position=position_dodge()) + 
  geom_errorbar(aes(ymin=Mean-SD, ymax=Mean+SD), width=.1, size=1, position=position_dodge(.9)) + 
  facet_wrap(~ScanHalf) + theme_classic() + 
  labs(title="Average Dwell Time", x="Group Connectivity State", y="Average Dwell Time (TRs)") + 
  theme(plot.title=element_text(hjust=0.5, size=16, face="bold"),
        plot.margin = unit(c(0,0,0,0), "lines"),
        axis.text=element_text(size=10),
        axis.title=element_text(size=14,face="bold"), 
        legend.title=element_text(size=12, face="bold"), 
        legend.text=element_text(size=10), 
        strip.text.x=element_text(size=12), 
        panel.background=element_rect(fill=NA, color="black"))

CS_group_transition_counts_halves_plot<-ggplot(scanhalves, aes(x=Transition_Tally_2cluster)) + 
  geom_histogram(aes(y=(..count../sum(..count..)), colour=Group, fill=Group), position="identity", binwidth=1, alpha=0.7) + 
  facet_wrap(~ScanHalf) + geom_vline(data=transitions_means, aes(xintercept=m, colour=Group), linetype="dashed", size=1) + 
  theme_classic() + labs(title="Transitions", x="Transitions", y="Relative Proportion of Subjects") + 
  theme(plot.title=element_text(hjust=0.5, size=16, face="bold"),
        plot.margin = unit(c(0,0,0,0), "lines"),
        axis.text=element_text(size=10),
        axis.title=element_text(size=14,face="bold"), 
        legend.title=element_text(size=12, face="bold"), 
        legend.text=element_text(size=10), 
        strip.text.x=element_text(size=12), 
        panel.background=element_rect(fill=NA, color="black"))




######
#####
####
###
##
# GROUP CS CENTROIDS
##
###
####
##### 
######
CS_1<-read.csv("ROUND1_group_CS_1_matrix.csv", header=TRUE)


# ORDER BY COG DOMAINS
# ORDER DETERMINED FROM Analysis/ROUND_1_INFOMAX/component_selection.xlsx "INFOMAX_cog_domains" sheet. "Ordered_Comp" indicates desired order of components after grouping. ColNum indicates the original unsorted column numbers (not component numbers because the outputs from MATLAB don't number columns according to the actual component number just based on index of component in the list of component numbers)
COMP_ORDER<-c(11, 22, 26, 35, 36, 37, 40, 42, 3, 14, 15, 18, 23, 27, 34, 38, 41, 1, 12, 28, 29, 30, 31 ,32 ,39, 2, 6, 8, 13, 4, 5, 17, 7, 9, 10, 16, 19, 20, 21 ,24, 25, 33)


CS_1<-CS_1[COMP_ORDER, COMP_ORDER]
diag(CS_1)=NA
COLNAMES<-colnames(CS_1)


CS_2<-read.csv("ROUND1_group_CS_2_matrix.csv", header=TRUE)
CS_2<-CS_2[COMP_ORDER, COMP_ORDER]
diag(CS_2)=NA




#Melt our matrices to expand our component numbers as rows rather than columns. Basically rearranges our matrix so that it isn't a matrix anymore but rather an array of the pairwise connectivity values. So ggplot can plot appropriately.
melted_CS_1 <- melt(as.matrix(CS_1))
melted_CS_2 <- melt(as.matrix(CS_2))

melted_CS_1$X1<-as.factor(melted_CS_1$X1)
melted_CS_2$X1<-as.factor(melted_CS_2$X1)


COMP_GROUP1<-c(rep("Cerebellar", 42), rep("CogControl", 42*7), rep("DMN", 42*9), rep("LangAud", 42*8), rep("Sensorimotor", 42*4), rep("Subcortical", 42*3), rep("Visual", 42*10))
COMP_GROUP2<-rep(c("Cerebellar", rep("CogControl", 7), rep("DMN", 9), rep("LangAud", 8), rep("Sensorimotor", 4), rep("Subcortical", 3), rep("Visual", 10)), 42)
#COMP_GROUP2<-c(rep(1, 42), rep(2, 42*7), rep(3, 42*9), rep(4, 42*8), rep(5, 42*4), rep(6, 42*3), rep(7, 42*10))

melted_CS_1$COMP_GROUP1<-COMP_GROUP1
melted_CS_2$COMP_GROUP2<-COMP_GROUP2

#Use ggplot to create geom_tile figure (matrix), X1 is essentially the component numbers, as is X2 (but in the pairwise fashion), value is then the correlation coefficient between the paired correlation of X1 and X2 (now just rearranged). Can change how many different colors appear in the matrix using the scale_fill_gradientn(colours=rainbow(#)) this option is fun to play around with to best display your range of values in the matrix. Do this plotting for both DX groups separately.


change_comp_labels<-c("X10" = "11", "X21" = "22", "X25" = "26", "X34" = "35", "X35" = "36", "X36" = "37", "X39" = "40", "X41" = "42", "X2" = "3", "X13" = "14", "X14" = "15", "X17" = "18", "X22" = "23", "X26" = "27", "X33" = "34", "X37" = "38", "X40" = "41", "X0" = "1", "X11" = "12", "X27" = "28", "X28" = "29", "X29" = "30", "X30" = "31", "X31" = "32", "X38" = "39", "X1" = "2", "X5" = "6", "X7" = "8", "X12" = "13", "X3" = "4", "X4" = "5", "X16" = "17", "X6" = "7", "X8" = "9", "X9" = "10", "X15" = "16", "X18" = "19", "X19" = "20", "X20" = "21", "X23" = "24", "X24" = "25", "X32" = "33")



plot_CS_1<-ggplot(data = melted_CS_1, aes(x=X2, y=X1)) +
  geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value)) +
  scale_fill_gradientn(colours=rev(rainbow(5)), na.value="#ffffff", guide=guide_colourbar(barheight=8, label.position="left", title="Correlation"), limit = c(0.4,0.9), space = "Lab") + 
  theme_classic() + 
  labs(title="CS #1", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
        plot.margin = unit(c(.2,0,0,0), "lines"), legend.position="left",
        legend.margin=margin(0,-15,0,0), legend.box.margin=margin(0,-20,0,0),
        axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold"), 
        legend.title=element_text(size=8, face="bold"), legend.text=element_text(size=6)) +
  scale_x_discrete(limits=unique(melted_CS_1$X2), labels=change_comp_labels) +
  scale_y_discrete(limits=unique(melted_CS_1$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') +
  annotate(geom = "text", x = 37, y=-2, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 31-0.5, y=-2, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 27-0.5, y=-2, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 21, y=-2, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 12, y=-2, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 4, y=-2, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 0.5, y=-2, label = "CB", hjust = "left", size=4)



plot_CS_2<-ggplot(data = melted_CS_2, aes(x=X2, y=X1)) +
  geom_tile_interactive(aes(fill=value, tooltip=round(value,3), data_id=value)) +
  scale_fill_gradientn(colours=rev(rainbow(5)), na.value="#ffffff", limit = c(0.4,0.9), space = "Lab", name="Correlation") + 
  theme_classic() + 
  labs(title="CS #2", x="", y="") + 
  theme(plot.title = element_text(hjust = 0.5, size=14,face="bold"), 
        plot.margin = unit(c(.2,2.2,0,0), "lines"), legend.position="none", 
        axis.text = element_text(size = 8), axis.title=element_text(size=18,face="bold")) + 
  scale_x_discrete(limits=unique(melted_CS_2$X2), labels=change_comp_labels) +
  scale_y_discrete(limits=unique(melted_CS_2$X1)) + 
  geom_vline(xintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) + 
  geom_hline(yintercept = c(1, 8, 17, 25, 29, 32, 42) + 0.5, size=1) +
  coord_cartesian(xlim=c(1,42), ylim=c(1,42), clip = 'off') + 
  annotate(geom = "text", x = 43, y = 37, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 43, y = 31, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 28-0.5, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 22-0.5, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 13, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 5, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 43, y = 1, label = "CB", hjust = "left", size=4) + 
  annotate(geom = "text", x = 37, y=-2, label = "VIS",hjust="left", size=4) + 
  annotate(geom = "text", x = 31-0.5, y=-2, label = "SC", hjust = "left", size=4) + 
  annotate(geom = "text", x = 27-0.5, y=-2, label = "SM", hjust = "left", size=4) + 
  annotate(geom = "text", x = 21, y=-2, label = "L/A", hjust = "left", size=4) + 
  annotate(geom = "text", x = 12, y=-2, label = "DMN", hjust = "left", size=4) + 
  annotate(geom = "text", x = 4, y=-2, label = "COG", hjust = "left", size=4) + 
  annotate(geom = "text", x = 0.5, y=-2, label = "CB", hjust = "left", size=4)

