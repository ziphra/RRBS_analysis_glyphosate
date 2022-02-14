#############################################
#################   PIPELINE   ##############
############################################# 

load("./filtering/09datalme4.RData")
load("pipeline2.RData")


`%notin%` <- Negate(`%in%`)
library(lme4qtl)
library(lme4)
library(ggplot2)
library(ggeffects, lib.loc="./pack")
library(emmeans, lib.loc="./pack")
library(sjPlot, lib.loc="./pack")
library(interactions, lib.loc ="./pack")
library(readr)
library(grid)
library(gridExtra)
library(dplyr)
library(pryr)
library(kableExtra, lib.loc="./pack")
library(tidyr)
library(tidyverse)

options(bitmapType='cairo')

colnames(meth_unmethFilt7)[12] = "unmeth_count"

# Data preparation:
# See dataprep.R and lme4_dataprep.md for the handling of methylation data
# and to switch methylation df from "wide" to "long"

# Filtering:
# To filter sites that have at least 10% differences between pairwise comparison 
# among the different sex/age/cond groups, see 09filtering.R

relatedness_matrix <- read_csv("relatedness_matrix.csv")

# 1. data prep ----
# * 1.1 make a relmat ----
# lme4qtl recquires the matrix to be a sparse matrix object. 
col = relatedness_matrix$X1
relatedness = subset(relatedness_matrix, select = -X1)
relatedness = as.matrix(relatedness)
row.names(relatedness) = col
relatedness <- as(relatedness, "sparseMatrix")  

relatedness = Matrix::forceSymmetric(relatedness,uplo="L")


# 2. create df to store results ----
sitestokeep = unique(c(sitestokeepM7, sitestokeepF7))
sitestokeep = sitestokeep[-3090]
n = length(sitestokeep)
l = length(sitestokeepF7)
m = length(sitestokeepM7)

## * 2.1 summ -----
# Keep all summaries. Might need to check them later?

cols = c("estimate", "std error", "t value", "p value")

GlyphEffect_GF.summ = GlyphEffect_KF.summ <- 
  data.frame(matrix(ncol = 4, nrow=l))

GlyphEffect_GM.summ = GlyphEffect_GM.summ = GlyphEffect_KM.summ <- 
  data.frame(matrix(ncol = 4, nrow=m))

full_M1.summ = full_M2.summ = full_F1.summ = full_F2.summ<-
  data.frame(matrix(ncol = 4, nrow=n))


colnames(GlyphEffect_GF.summ) = colnames(GlyphEffect_KF.summ) = colnames(GlyphEffect_GM.summ) = colnames(GlyphEffect_KM.summ) = colnames(full_F1.summ) = colnames(full_F2.summ) = colnames(full_M2.summ) = colnames(full_M1.summ) <- 
  cols

rownames(GlyphEffect_GF.summ) = rownames(GlyphEffect_KF.summ) <- 
  sitestokeepF7


rownames(GlyphEffect_GM.summ) = rownames(GlyphEffect_KM.summ) <- 
  sitestokeepM7

rownames(full_F1.summ) = rownames(full_F2.summ) = rownames(full_M1.summ) = rownames(full_M2.summ) <-
  sitestokeep

## # * 2.2 var ----
GlyphEffectF.stdev <- 
  data.frame(matrix(ncol = 1, nrow = l))

GlyphEffectM.stdev <- 
  data.frame(matrix(ncol = 1, nrow = m))

full.stdev <- 
  data.frame(matrix(ncol = 1, nrow = n))

colnames(GlyphEffectF.stdev) = colnames(GlyphEffectM.stdev) = colnames(full.stdev) <- 
  "stdev"

rownames(GlyphEffectF.stdev) = sitestokeepF7

rownames(GlyphEffectM.stdev) = sitestokeepM7

rownames(full.stdev) = sitestokeep

## * 2.3 warning ----
warning.full <- vector("list", n)
warning.glyphF <- vector("list", l)
warning.glyphM <- vector("list", m)
names(warning.full) = sitestokeep
names(warning.glyphF) = sitestokeepF7
names(warning.glyphM) = sitestokeepM7


## * 2.4 p val -----
# for plotting p value distribution. 
allpval.fullF = c()
allpval.fullM = c()
allpval.glyphF = c()
allpval.glyphM = c()


## * 2.5 contrasts ----
contrasts.full = data.frame(matrix(ncol = 7, nrow = 0))
contrasts.glyphF = data.frame(matrix(ncol = 7, nrow = 0))
contrasts.glyphM = data.frame(matrix(ncol = 7, nrow = 0))


## * 2.6 significant sites ---- 
significant.sites = data.frame(matrix(ncol = 2, nrow=n))
colnames(significant.sites) = c("full.F","full.M")
rownames(significant.sites) = sitestokeep

significant.sitesGF = data.frame(matrix(nrow=l))
rownames(significant.sitesGF) = sitestokeepF7
colnames(significant.sitesGF) = c("glyph")


significant.sitesGM = data.frame(matrix(ncol = 1, nrow=m))
rownames(significant.sitesGM) = sitestokeepM7
colnames(significant.sitesGM) = c("glyph")


# 3. loop ----
for (site in 1:n){
  sitetotest = subset(meth_unmethFilt7, meth_unmethFilt7$chrpos1==sitestokeep[site])
  print(site)
  
  
  ## * 3.3 model 2: full ----
  full <-  relmatGlmer(cbind(sitetotest$meth_count,sitetotest$unmeth_count) 
                       ~ sex*cond + (1|ID12), data = sitetotest, 
                       relmat = list(ID12 = relatedness), 
                       family="binomial",
                       optimizer="bobyqa"
                       #nAGQ=0
  )
  
  full_F1.summ[sitestokeep[site],] = summary(full)$coefficient["(Intercept)",]
  full_M1.summ[sitestokeep[site],] = summary(full)$coefficient["sexM",]
  full_F2.summ[sitestokeep[site],] = summary(full)$coefficient["cond2",]
  full_M2.summ[sitestokeep[site],] = summary(full)$coefficient["sexM:cond2",]
  full.stdev[sitestokeep[site],]= VarCorr(full)$ID12[1,1]
  
  #warning 
  if (is.null(full@optinfo$conv$lme4$messages)==FALSE){
    warning.full[sitestokeep[site]] = full@optinfo$conv$lme4$messages
  }
  
  # * * 3.3.1 contrasts ----
  emfull = emmeans(full, specs = pairwise ~ cond|sex, type = "response")
  emfull.contrasts = as.data.frame(emfull$contrasts)
  

  allpval.fullF = c(allpval.fullF,emfull.contrasts[1,7])
  allpval.fullM = c(allpval.fullM,emfull.contrasts[2,7])
  
  
  # if F1 significantly different from F2, keep contrasts output and sites
  if (emfull.contrasts[1,7] <= 0.05){
    cbcfull = cbind(emfull.contrasts[1,], sitestokeep[site])
    contrasts.full = rbind(contrasts.full,cbcfull)
    
    significant.sites[sitestokeep[site], "full.F"] = emfull.contrasts[1,7]
  }
  # if M1 significantly different from M2, keep contrasts output and sites
  if (emfull.contrasts[2,7] <= 0.05){
    cbcfull = cbind(emfull.contrasts[2,], sitestokeep[site])
    contrasts.full = rbind(contrasts.full,cbcfull)
    significant.sites[sitestokeep[site], "full.M"] = emfull.contrasts[2,7]
  }
  
}



# glyph. effect F -----
for (sitef in 1:l){
  sitetotestF7 = subset(meth_unmethFilt7, meth_unmethFilt7$chrpos1==sitestokeepF7[sitef])
  print(sitef)
  
  ## * 3.1 model 1: glypheffect ----
  GlyphEffect <-  relmatGlmer(cbind(sitetotestF7$meth_count,sitetotestF7$unmeth_count) 
                              ~ cond + (1|ID12), data = sitetotestF7,
                              relmat = list(ID12 = relatedness),
                              family="binomial",
                              optimizer="bobyqa"
                              #nAGQ=0
  )
  
  GlyphEffect_GF.summ[sitestokeepF7[sitef],] = summary(GlyphEffect)$coefficient["(Intercept)",] 
  GlyphEffect_KF.summ[sitestokeepF7[sitef],] = summary(GlyphEffect)$coefficient["cond2",]
  GlyphEffectF.stdev[sitestokeepF7[sitef],] = VarCorr(GlyphEffect)$ID12[1,1]
  
  #warning
  if (is.null(GlyphEffect@optinfo$conv$lme4$messages)==FALSE){
    warning.glyphF[sitestokeepF7[sitef]] = GlyphEffect@optinfo$conv$lme4$messages
  }
  
  
  
  # * * 3.1.1 contrasts ----
  emglyph = emmeans(GlyphEffect, specs = pairwise ~ cond, type = "response")
  emglyph.contrasts = as.data.frame(emglyph$contrasts)
  
  allpval.glyphF = c(allpval.glyphF, emglyph.contrasts[1,6])
  
  
  # if G significantly different from K, keep contrasts output and sites
  if (emglyph.contrasts[1,6] <= 0.05){
    cbcg = cbind(emglyph.contrasts[1,], sitestokeepF7[sitef])
    contrasts.glyphF = rbind(contrasts.glyphF,cbcg) 
    
    significant.sitesGF[sitestokeepF7[sitef],"glyph"] = emglyph.contrasts[1,6]
  }
  
}





# glyph. effect M -----
for (sitem in 1:m){
  sitetotestM7 = subset(meth_unmethFilt7, meth_unmethFilt7$chrpos1==sitestokeepM7[sitem])
  print(sitem)
  
  ## * 3.1 model 1: glypheffect ----
  GlyphEffectM <-  relmatGlmer(cbind(sitetotestM7$meth_count,sitetotestM7$unmeth_count) 
                               ~ cond + (1|ID12), data = sitetotestM7,
                               relmat = list(ID12 = relatedness),
                               family="binomial",
                               optimizer="bobyqa"
                               #nAGQ=0
  )
  
  GlyphEffect_GM.summ[sitestokeepM7[sitem],] = summary(GlyphEffectM)$coefficient["(Intercept)",] 
  GlyphEffect_KM.summ[sitestokeepM7[sitem],] = summary(GlyphEffectM)$coefficient["cond2",]
  GlyphEffectM.stdev[sitestokeepM7[sitem],] = VarCorr(GlyphEffectM)$ID12[1,1]
  
  #warning
  if (is.null(GlyphEffectM@optinfo$conv$lme4$messages)==FALSE){
    warning.glyphM[sitestokeepM7[sitem]] = GlyphEffectM@optinfo$conv$lme4$messages
  }
  
  
  
  # * * 3.1.1 contrasts ----
  emglyphM = emmeans(GlyphEffectM, specs = pairwise ~ cond, type = "response")
  emglyphM.contrasts = as.data.frame(emglyphM$contrasts)
  allpval.glyphM = c(allpval.glyphM, emglyphM.contrasts[1,6])
  
  
  # if G significantly different from K, keep contrasts output and sites
  if (emglyphM.contrasts[1,6] <= 0.05){
    cbcgm = cbind(emglyphM.contrasts[1,], sitestokeepM7[sitem])
    contrasts.glyphM = rbind(contrasts.glyphM,cbcgm) 
  }
  
}




# 4. results ----
## * 4.1 warnings ----
# full 
#store all warnings and sites where it occurs

short_warning.full = Filter(Negate(is.null), warning.full)
print(paste0("Full: there were ", length(short_warning.full)," warnings")) #77 

# count warning type 
sing = 0 
una = 0 
conv = 0 
for (i in 1:length(short_warning.full)){
  if (short_warning.full[i] == "boundary (singular) fit: see ?isSingular"){
    sing = sing + 1}
  else if (short_warning.full[i] == "unable to evaluate scaled gradient"){
    una = una + 1
  }
  else {
    conv = conv + 1
  }
}

print(paste0("of which ", sing," were: 'boundary (singular) fit: see ?isSingular'")) #5
print(paste0(una, " were: 'unable to evaluate scaled gradient'")) #5
print(paste0(conv, " were: 'Model failed to converge with max|grad| = x (tol = 0.002, component 1)'")) #67



#glyph F 
singF = 0 
unaF = 0 
convF = 0 
short_warning.glyphF = Filter(Negate(is.null), warning.glyphF)
print(paste0("there were ", length(short_warning.glyphF)," warnings")) #21

# count singular warning 
for (i in 1:length(short_warning.glyphF)){
  if (short_warning.glyphF[i] == "boundary (singular) fit: see ?isSingular"){
    singF = singF + 1}
  else if (short_warning.glyphF[i] == "unable to evaluate scaled gradient"){
    unaF = unaF + 1
  }
  else {
    convF = convF + 1
  }
}


print(paste0("of which ", singF," were: 'boundary (singular) fit: see ?isSingular'")) #1
print(paste0(unaF, " were: 'unable to evaluate scaled gradient'")) #0
print(paste0(convF, " were: 'Model failed to converge with max|grad| = x (tol = 0.002, component 1)'")) #20




#glyph M 
singM = 0 
unaM = 0 
convM = 0 
short_warning.glyphM = Filter(Negate(is.null), warning.glyphM)
print(paste0("there were ", length(short_warning.glyphM)," warnings")) #43

# count singular warning 
for (i in 1:length(short_warning.glyphM)){
  if (short_warning.glyphM[i] == "boundary (singular) fit: see ?isSingular"){
    singM = singM + 1}
  else if (short_warning.glyphM[i] == "unable to evaluate scaled gradient"){
    unaM = unaM + 1
  }
  else {
    convM = convM + 1
  }
}


print(paste0("of which ", singM," were: 'boundary (singular) fit: see ?isSingular'")) #2
print(paste0(unaM, " were: 'unable to evaluate scaled gradient'")) #0
print(paste0(convM, " were: 'Model failed to converge with max|grad| = x (tol = 0.002, component 1)'")) #41

## * 4.2 differentially methylated sites ----
# significant sites #2 
short_significant.sitesGM = contrasts.glyphM[,c(7,6)] #727
short_significant.sitesGF = contrasts.glyphF[,c(7,6)] #516
short_significant.sitesFull = contrasts.full[, c(2,8,7)] #1942

warningnamesGM = names(short_warning.glyphM)
shorterGM = filter(short_significant.sitesGM, `sitestokeepM7[sitem]`%notin%warningnamesGM) #684

warningnamesGF = names(short_warning.glyphF)
shorterGF = filter(short_significant.sitesGF, `sitestokeepF7[sitef]`%notin%warningnamesGF) #495

warningnamesFull = names(short_warning.full)
shorterFull = filter(short_significant.sitesFull, `sitestokeep[site]`%notin%warningnamesFull) #1808



# 5. plot ---- 
## * 5.1 cat plot ----

catplot.list = c()

for (site in selectedsite){
  
  sitetotest = subset(meth_unmethFilt, meth_unmethFilt$chrpos1==sitestokeep[site])
  
  full <-  relmatGlmer(cbind(sitetotest$meth_count,sitetotest$unmeth_count) 
                       ~ sex*cond + (1|ID12), data = sitetotest, 
                       relmat = list(ID12 = relatedness), 
                       family="binomial",
                       optimizer="bobyqa"
                       #nAGQ=0
  )
  
  catplot.list[[site]] = cat_plot(full, pred = cond, modx = sex,
                                  data = sitetotest,
                                  x.label = "treatment",
                                  y.label = "methylation",
                                  main.title = sitestokeep[site],
                                  line.thickness =0.5,
                                  pred.point.size = 2
  )
  
  ggsave(
    sprintf("./plot/%s_catplotfull.png", sitestokeep[site]),
    device = png(),
    plot = catplot.list[[z]],
    scale = 1,
    width = 16,
    height = 16,
    units = "cm",
    dpi = 600,
    limitsize = FALSE,
  )
  dev.off()
  
}


catplot.arranged = do.call(grid.arrange, c(catplot.list, ncol = 10))

ggsave(
  ("./plot/catplot.arranged.png"),
  device = png(),
  plot = catplot.arranged,
  scale = 1,
  width = 80,
  height = 150,
  units = "cm",
  dpi = 300,
  limitsize = FALSE,
)   

dev.off()



## * 5.2 p value ----
#plot 
allpvalplotf = data.frame(matrix(ncol = 2, nrow = length(allpval.fullF)))
allpvalplotm = data.frame(matrix(ncol = 2, nrow = length(allpval.fullM)))
allpvalplotf$X1 = allpval.fullF
allpvalplotm$X1 = allpval.fullM
allpvalplotf$X2 = 1
allpvalplotm$X2 = 2
allpvalplot = rbind(allpvalplotf,allpvalplotm)
allpvalplot[allpvalplot==0]<-NA
allpvalplot$X2 = as.factor(allpvalplot$X2)

((full_pval.plot = ggplot(allpvalplot, aes(x=X1, color=X2, fill=X2))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    facet_wrap(~X2)+
    labs(title="p value distribution - Full model",
         x="p value")+
    scale_fill_discrete(labels = c("Female", "Male"))+
    scale_color_discrete(labels = c("Female", "Male"))+
    theme_minimal()
))


allpval.glyphF = as.data.frame(allpval.glyphF)
allpval.glyphF[allpval.glyphF==0]<-NA

((glyphF_pval.plot = ggplot(allpval.glyphF, aes(x=allpval.glyphF))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    xlab("p value")+
    theme_minimal()+
    ggtitle("p value distribution - GlyphF model" )
))



allpval.glyphM = as.data.frame(allpval.glyphM)
allpval.glyphM[allpval.glyphM==0]<-NA

((glyphM_pval.plot = ggplot(allpval.glyphM, aes(x=allpval.glyphM))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    xlab("p value")+
    theme_minimal()+
    ggtitle("p value distribution - GlyphM model" )
))

ggsave(
  ("./plot/full_pval.png"),
  device = png(),
  plot = full_pval.plot,
  scale = 1,
  width = 12,
  height = 9,
  units = "cm",
  dpi = 600,
  limitsize = FALSE,
)   

dev.off()


# 6. FDR -----
library(fdrtool)

#full
#* * 6.1 fdrtool----
pvalfull.corr = allpval.full
pvalfull.corr[,3] = c(sitestokeep,sitestokeep)
pvalfull.corr = filter(pvalfull.corr, !is.na(pvalfull.corr$X1))
fdr.full = fdrtool(pvalfull.corr$X1, statistic="pvalue")

pvalfull.corr[,4] = fdr.full$qval

((full_pvalcorr.plot = ggplot(pvalfull.corr, aes(x=V4, color=X2, fill=X2))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    facet_wrap(~X2)+
    labs(title="p value distribution for \n F1/F2 and M1/M2 contrasts",
         x="p value")+
    scale_fill_discrete(labels = c("Female", "Male"))+
    scale_color_discrete(labels = c("Female", "Male"))+
    theme_minimal()
))


table_sig_fullF = pvalfull.corr[which(pvalfull.corr$V4<=0.05&pvalfull.corr$X2==1),]


length(which(pvalfull.corr$V4<=0.05)) #167


#* * 6.2 padjust ----
pvalfull.corr2 = pvalfull.corr[order(pvalfull.corr$X1),]
pvalfull.corr2[,4] = p.adjust(pvalfull.corr2$X1, method="fdr")

length(which(pvalfull.corr2$V4<=0.05)) #145



#glyph
pvalglyph.corr = allpval.glyph
pvalglyph.corr[,2] = sitestokeep
pvalglyph.corr = filter(pvalglyph.corr, !is.na(pvalglyph.corr$X1))
fdr.glyph = fdrtool(pvalglyph.corr$X1, statistic="pvalue")

pvalglyph.corr[,3] = fdr.glyph$qval

((glyph_pvalcorr.plot = ggplot(pvalglyph.corr, aes(x=V3))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    xlab("p value")+
    theme_minimal()+
    ggtitle("p value distribution for treatment contrasts" )
))

length(which(pvalglyph.corr$V3<=0.05)) # 61


#padjust 
pvalglyph.corr2 = pvalglyph.corr[order(pvalglyph.corr$X1),]
pvalglyph.corr2[,3] = p.adjust(pvalglyph.corr2$X1, method="fdr")

length(which(pvalglyph.corr2$V3<=0.05)) #57

#sex
pvalsex.corr = allpval.sex
pvalsex.corr[,2] = sitestokeep
pvalsex.corr = filter(pvalsex.corr, !is.na(pvalsex.corr$X1))
fdr.sex = fdrtool(pvalsex.corr$X1, statistic="pvalue")

pvalsex.corr[,3] = fdr.sex$qval

((sex_pvalcorr.plot = ggplot(pvalsex.corr, aes(x=V3))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    xlab("p value")+
    theme_minimal()+
    ggtitle("p value distribution for treatment contrasts" )
))

length(which(pvalsex.corr$V3<=0.05)) #2730


#padjust
pvalsex.corr2 = pvalsex.corr[order(pvalsex.corr$X1),]
pvalsex.corr2[,3] = p.adjust(pvalsex.corr2$X1, method="fdr")

length(which(pvalsex.corr2$V3<=0.05)) #2313


# * * 6.3 for p comb ----
allpval.fullF.df = data_frame(allpval.fullF)
rownames(allpval.fullF.df) = sitestokeep
short_allpval.fullF.df = filter(allpval.fullF.df, rownames(allpval.fullF.df)%notin%warningnamesFull) #5153
write.table(short_allpval.fullF.df, file = "pv_fullF.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)


allpval.fullM.df = data_frame(allpval.fullM)
rownames(allpval.fullM.df) = sitestokeep
short_allpval.fullM.df = filter(allpval.fullM.df, rownames(allpval.fullM.df)%notin%warningnamesFull) #5153
write.table(short_allpval.fullM.df, file = "pv_fullM.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)




allpval.glyphF.df = data_frame(allpval.glyphF)
rownames(allpval.glyphF.df) = sitestokeepF7
short_allpval.glyphF.df = filter(allpval.glyphF.df, rownames(allpval.glyphF.df)%notin%warningnamesGF) #5153
write.table(short_allpval.glyphF.df, file = "pv_fullGF7.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)



allpval.glyphM.df = data_frame(allpval.glyphM)
rownames(allpval.glyphM.df) = sitestokeepM7
short_allpval.glyphM.df = filter(allpval.glyphM.df, rownames(allpval.glyphM.df)%notin%warningnamesGM) #5153
write.table(short_allpval.glyphM.df, file = "pv_fullGM7.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)


# save ... ----

save(meth_unmeth12,
     sitestokeep,
     file = "data_pip12.RData")

save(allpval.full,allpval.glyph,allpval.sex,
     sig.model,
     short_significant.sites,
     short_warning.full,short_warning.glyph,short_warning.sex,
     una,una2,una3,
     conv,conv2,conv3,
     sing,sing2,sing3,
     file = "rmd12.RData")






# rmd ----
matrixtobe = c(1,2,5,
               0,0,5,
               20,41,67,
               21,43,77)

table = matrix(matrixtobe, ncol = 3, byrow = TRUE)

colnames(table)=c("Glyph F",
                  "Glyph M", 
                  "Full"
)

rownames(table)=c("'?isSingular'","'unable to evaluate scaled gradient'", "'Model failed to converge","all")





matrixtobe2 = c(516,727,1942,
                495,684,1808)

table2 = matrix(matrixtobe2, ncol = 3, byrow = TRUE)

colnames(table2)=c("Glyph F",
                   "Glyph M", 
                   "Full"
)

rownames(table2)=c("sites with p.value < .05", "without sites issued warnings")

save(full_pval.plot,
     glyphF_pval.plot,
     glyphM_pval.plot,
     table,
     table2,
     file = "plot.RData")

load("rmd12.RData")

save.image(file="pipeline_12_2.RData")

write.table(short_significant.sites, file = "short_significant.sites.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)

write.table(table_sig_fullF, file = "sigsitefullf.txt", sep = "\t",
            row.names = FALSE, col.names = FALSE)


write.table(sitestokeep, file = "sitestokeep.txt", sep = "\n",
            row.names = FALSE, col.names = FALSE)

write.table(datamp_long$chrpos1, file = "sites10x.txt", sep = "\t",
            row.names = FALSE, col.names = FALSE)



pv_fullF= allpval.full2[allpval.full2$X2=="1",]
pv_fullF = select(pv_fullF2,1)
pv_fullF = subset(pv_fullF2, rownames(pv_fullF)!="NA" )
row.names(pv_fullF2) = sitestokeep
pv_fullF = filter(pv_fullF2, !is.na(pv_fullF2$X1)) 
write.table(pv_fullF, file = "pv_fullF.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)


pv_fullM = allpval.full[allpval.full$X2=="2",]
pv_fullM = select(pv_fullM,1)
pv_fullM = subset(pv_fullM, rownames(pv_fullM)!="NA" )
row.names(pv_fullM) = 22
pv_fullM = filter(pv_fullM, !is.na(pv_fullM$X1)) 
write.table(pv_fullM, file = "pv_fullM.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)






save.image("pipeline2.RData")
