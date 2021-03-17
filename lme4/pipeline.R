#############################################
#################  PIPELINE  ################ 
############################################# 
load("pipeline_7.RData")

load("data_pip7.RData")

library(lme4qtl)
library(lme4)
library(ggplot2)
library(ggeffects, lib.loc="./pack")
library(emmeans, lib.loc="./pack")
library(sjPlot, lib.loc="./pack")
library("interactions", lib.loc ="./pack")
library(readr)
library(grid)
library(gridExtra)
library(dplyr)
library(pryr)
library(kableExtra, lib.loc="./pack")

options(bitmapType='cairo')


# Data preparation:
# See dataprep.R and lme4_dataprep.md for the handling of methylation data
# and to switch methylation df from "wide" to "long"

# Filtering:
# To filter sites that have at least 5% differences between pairwise comparison 
# among the different sex/age/cond groups, see filtering.R
load(file ="data_pip7.RData")

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
n = length(sitestokeep.list)

## * 2.1 summ -----
# Keep all summaries. Might need to check them later?

cols = c("estimate", "std error", "t value", "p value")
SexEffect_F.summ = SexEffect_M.summ = GlyphEffect_G.summ = GlyphEffect_K.summ = full_F1.summ = full_M1.summ = full_F2.summ = full_M2.summ <- 
  data.frame(matrix(ncol = 4, nrow=n))


colnames(SexEffect_F.summ) = colnames(SexEffect_M.summ) = colnames(GlyphEffect_G.summ) = colnames(GlyphEffect_K.summ) = colnames(full_F1.summ) = colnames(full_F2.summ) = colnames(full_M2.summ) = colnames(full_M1.summ) <- 
  cols

rownames(SexEffect_F.summ) = rownames(SexEffect_M.summ) = rownames(GlyphEffect_G.summ) = rownames(GlyphEffect_K.summ) = rownames(full_F1.summ) = rownames(full_F2.summ) = rownames(full_M2.summ) = rownames(full_M1.summ) <- 
  sitestokeep.list

## # * 2.2 var ----
GlyphEffect.stdev = full.stdev = SexEffect.stdev <- 
  data.frame(matrix(ncol = 1, nrow = n))

colnames(GlyphEffect.stdev) = colnames(full.stdev) =  colnames(SexEffect.stdev) <- 
  "stdev"
rownames(GlyphEffect.stdev) = rownames(full.stdev) =  rownames(SexEffect.stdev) <-
  sitestokeep.list

## * 2.3 warning ----
warning.full <- vector("list", n)
warning.sex <- vector("list", n)
warning.glyph <- vector("list", n)
names(warning.full) = sitestokeep.list
names(warning.glyph) = sitestokeep.list
names(warning.sex) = sitestokeep.list

## * 2.4 p val -----
# for plotting p value distribution. 
allpval.full = data.frame(matrix(ncol = 2, nrow=0))
allpval.glyph = data.frame(matrix(ncol = 2, nrow=0))
allpval.sex = data.frame(matrix(ncol = 2, nrow=0))

## * 2.5 contrasts ----
contrasts.full = data.frame(matrix(ncol = 7, nrow = 0))
contrasts.glyph = data.frame(matrix(ncol = 7, nrow = 0))
contrasts.sex = data.frame(matrix(ncol = 7, nrow = 0))


## * 2.6 significant sites ---- 
significant.sites = data.frame(matrix(ncol = 4, nrow=n))
colnames(significant.sites) = c("full.F","full.M","glyph","sex")
rownames(significant.sites) = sitestokeep.list




# 3. loop ----
for (site in 1:n){
  sitetotest = subset(meth_unmethFilt, meth_unmethFilt$chrpos1==sitestokeep.list[site])
  print(site)
  
  ## * 3.1 model 1: glypheffect ----
  GlyphEffect <-  relmatGlmer(cbind(sitetotest$meth_count,sitetotest$unmeth_count) 
                              ~ cond + (1|ID12), data = sitetotest,
                              relmat = list(ID12 = relatedness),
                              family="binomial",
                              optimizer="bobyqa"
                              #nAGQ=0
  )
  
  GlyphEffect_G.summ[sitestokeep.list[site],] = summary(GlyphEffect)$coefficient["(Intercept)",] 
  GlyphEffect_K.summ[sitestokeep.list[site],] = summary(GlyphEffect)$coefficient["cond2",]
  GlyphEffect.stdev[sitestokeep.list[site],] = VarCorr(GlyphEffect)$ID12[1,1]
  
  #warning
  if (is.null(GlyphEffect@optinfo$conv$lme4$messages)==FALSE){
    warning.glyph[sitestokeep.list[site]] = GlyphEffect@optinfo$conv$lme4$messages
  }
  
  
  
  # * * 3.1.1 contrasts ----
  emglyph = emmeans(GlyphEffect, specs = pairwise ~ cond, type = "response")
  emglyph.contrasts = as.data.frame(emglyph$contrasts)
  allpval.glyph[site,1] = emglyph.contrasts[1,6]
  
  
  # if G significantly different from K, keep contrasts output and sites
  if (emglyph.contrasts[1,6] <= 0.05){
    cbcg = cbind(emglyph.contrasts[1,], sitestokeep.list[site])
    contrasts.glyph = rbind(contrasts.glyph,cbcg) 
    
    significant.sites[sitestokeep.list[site], "glyph"] = emglyph.contrasts[1,6]
  }
  
  ## * 3.2 model 2: sex effect ----
  SexEffect <-  relmatGlmer(cbind(sitetotest$meth_count,sitetotest$unmeth_count) 
                            ~ sex + (1|ID12), data = sitetotest,
                            relmat = list(ID12 = relatedness),
                            family="binomial",
                            optimizer="bobyqa"
                            #nAGQ=0
  )
  
  SexEffect_F.summ[sitestokeep.list[site],] = summary(SexEffect)$coefficient["(Intercept)",] 
  SexEffect_M.summ[sitestokeep.list[site],] = summary(SexEffect)$coefficient["sexM",]
  SexEffect.stdev[sitestokeep.list[site],] = VarCorr(SexEffect)$ID12[1,1]
  
  #warning
  if (is.null(SexEffect@optinfo$conv$lme4$messages)==FALSE){
    warning.sex[sitestokeep.list[site]] = SexEffect@optinfo$conv$lme4$messages
  }
  
  # * * 3.2.1 contrasts ----
  emsex = emmeans(SexEffect, specs = pairwise ~ sex, type = "response")
  emsex.contrasts = as.data.frame(emsex$contrasts)
  allpval.sex[site,1] = emsex.contrasts[1,6]
  
  # if F significantly different from M, keep contrasts output and sites
  if (emsex.contrasts[1,6] <= 0.05){
    cbcsex = cbind(emsex.contrasts[1,], sitestokeep.list[site])
    contrasts.sex = rbind(contrasts.sex,cbcsex) 
    
    significant.sites[sitestokeep.list[site], "sex"] = emsex.contrasts[1,6]
  }
  
  
  ## * 3.3 model 2: full ----
  full <-  relmatGlmer(cbind(sitetotest$meth_count,sitetotest$unmeth_count) 
                       ~ sex*cond + (1|ID12), data = sitetotest, 
                       relmat = list(ID12 = relatedness), 
                       family="binomial",
                       optimizer="bobyqa"
                       #nAGQ=0
  )

  full_F1.summ[sitestokeep.list[site],] = summary(full)$coefficient["(Intercept)",]
  full_M1.summ[sitestokeep.list[site],] = summary(full)$coefficient["sexM",]
  full_F2.summ[sitestokeep.list[site],] = summary(full)$coefficient["cond2",]
  full_M2.summ[sitestokeep.list[site],] = summary(full)$coefficient["sexM:cond2",]
  full.stdev[sitestokeep.list[site],]= VarCorr(full)$ID12[1,1]
  
  #warning 
  if (is.null(full@optinfo$conv$lme4$messages)==FALSE){
    warning.full[sitestokeep.list[site]] = full@optinfo$conv$lme4$messages
  }
  
  # * * 3.3.1 contrasts ----
  emfull = emmeans(full, specs = pairwise ~ cond|sex, type = "response")
  emfull.contrasts = as.data.frame(emfull$contrasts)
  
  allpval.full[site,1] = emfull.contrasts[1,7]
  allpval.full[(site+length(sitestokeep.list)),1] = emfull.contrasts[2,7]
  allpval.full[site,2] = emfull.contrasts[1,2]
  allpval.full[(site+length(sitestokeep.list)),2] = emfull.contrasts[2,2]
  
  # if F1 significantly different from F2, keep contrasts output and sites
  if (emfull.contrasts[1,7] <= 0.05){
    cbcfull = cbind(emfull.contrasts[1,], sitestokeep.list[site])
    contrasts.full = rbind(contrasts.full,cbcfull)
    
    significant.sites[sitestokeep.list[site], "full.F"] = emfull.contrasts[1,7]
  }
  # if M1 significantly different from M2, keep contrasts output and sites
  if (emfull.contrasts[2,7] <= 0.05){
    cbcfull = cbind(emfull.contrasts[2,], sitestokeep.list[site])
    contrasts.full = rbind(contrasts.full,cbcfull)
    significant.sites[sitestokeep.list[site], "full.M"] = emfull.contrasts[2,7]
  }
  
}


# 4. results ----
## * 4.1 warnings ----
# full 
#store all warnings and sites where it occurs

short_warning.full = Filter(Negate(is.null), warning.full)
print(paste0("Full: there were ", length(short_warning.full)," warnings"))

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

print(paste0("of which ", sing," were: 'boundary (singular) fit: see ?isSingular'"))
print(paste0(una, " were: 'unable to evaluate scaled gradient'"))
print(paste0(conv, " were: 'Model failed to converge with max|grad| = x (tol = 0.002, component 1)'"))

#sex 
short_warning.sex = Filter(Negate(is.null), warning.sex)
print(paste0("there were ", length(short_warning.sex)," warnings"))

# count warning type 
sing2 = 0 
una2 = 0 
conv2 = 0 
for (i in 1:length(short_warning.sex)){
  if (short_warning.sex[i] == "boundary (singular) fit: see ?isSingular"){
    sing2 = sing2 + 1}
  else if (short_warning.sex[i] == "unable to evaluate scaled gradient"){
    una2 = una2 + 1
  }
  else {
    conv2 = conv2 + 1
  }
}


print(paste0("of which ", sing2," were: 'boundary (singular) fit: see ?isSingular'"))
print(paste0(una2, " were: 'unable to evaluate scaled gradient'"))
print(paste0(conv2, " were: 'Model failed to converge with max|grad| = x (tol = 0.002, component 1)'"))


#glyph 
sing3 = 0 
una3 = 0 
conv3 = 0 
short_warning.glyph = Filter(Negate(is.null), warning.glyph)
print(paste0("there were ", length(short_warning.glyph)," warnings"))

# count singular warning 
for (i in 1:length(short_warning.glyph)){
  if (short_warning.glyph[i] == "boundary (singular) fit: see ?isSingular"){
    sing3 = sing3 + 1}
  else if (short_warning.glyph[i] == "unable to evaluate scaled gradient"){
    una3 = una3 + 1
  }
  else {
    conv3 = conv3 + 1
  }
}


print(paste0("of which ", sing3," were: 'boundary (singular) fit: see ?isSingular'"))
print(paste0(una3, " were: 'unable to evaluate scaled gradient'"))
print(paste0(conv3, " were: 'Model failed to converge with max|grad| = x (tol = 0.002, component 1)'"))

## * 4.2 differentially methylated sites ----
nrow(significant.sites)
#delete rows containing only NA's

short_significant.sites <- significant.sites[rowSums(is.na(significant.sites)) != ncol(significant.sites), ]

nrow(short_significant.sites) 


short_significant.sites[short_significant.sites==0]<-NA
short_significant.sites <- short_significant.sites[rowSums(is.na(short_significant.sites)) != ncol(short_significant.sites), ]


# 7231 afetr removing p.value == 0 

summary(short_significant.sites)
sig.FF = length(na.omit(short_significant.sites$full.F)) #3115
sig.FM = length(na.omit(short_significant.sites$full.M)) #2274
sig.G = length(na.omit(short_significant.sites$glyph)) #2279
sig.S = length(na.omit(short_significant.sites$sex)) #1714


sig.FFM = 0 
sig.FFG = 0 
sig.FMG = 0 
sig.FFS = 0 
sig.FMS = 0 
sig.GS = 0 
sig.FFMS = 0 
sig.FFMG = 0 
all = 0 

for (site in 1:length(short_significant.sites$full.F)){
  
  if (!is.na(short_significant.sites[site,"full.F"]) == TRUE 
      & !is.na(short_significant.sites[site,"full.M"]) == TRUE){
    sig.FFM  = sig.FFM  + 1
  }
  
  if (!is.na(short_significant.sites[site,"full.F"]) == TRUE 
      & !is.na(short_significant.sites[site,"glyph"] == TRUE)){
    sig.FFG = sig.FFG + 1
  }
  
  if (!is.na(short_significant.sites[site,"full.M"]) == TRUE 
      & !is.na(short_significant.sites[site,"glyph"] == TRUE)){
    sig.FMG = sig.FMG + 1
  }
  
  if (!is.na(short_significant.sites[site,"full.F"]) == TRUE 
      & !is.na(short_significant.sites[site,"sex"]) == TRUE){
    sig.FFS = sig.FFS + 1
  }
  
  if (!is.na(short_significant.sites[site,"full.M"]) == TRUE 
      & !is.na(short_significant.sites[site,"sex"]) == TRUE){
    sig.FMS = sig.FMS + 1
  }
  
  if (!is.na(short_significant.sites[site,"glyph"]) == TRUE 
      & !is.na(short_significant.sites[site,"sex"]) == TRUE){
    sig.GS = sig.GS + 1
  }
  
  if (!is.na(short_significant.sites[site,"full.M"]) == TRUE 
      & !is.na(short_significant.sites[site,"full.F"]) == TRUE 
      & !is.na(short_significant.sites[site,"sex"])){
    sig.FFMS = sig.FFMS + 1
  }
  
  if (!is.na(short_significant.sites[site,"full.M"]) == TRUE
      & !is.na(short_significant.sites[site,"full.F"]) == TRUE
      & !is.na(short_significant.sites[site,"glyph"]) == TRUE){
    sig.FFMG = sig.FFMG + 1
  }
  
  if (!is.na(short_significant.sites[site,"full.M"]) == TRUE
      & !is.na(short_significant.sites[site,"full.F"]) == TRUE 
      & !is.na(short_significant.sites[site,"sex"]) == TRUE
      & !is.na(short_significant.sites[site,"glyph"]) == TRUE){
    all = all + 1
  }
}


sig.FFM  
sig.FFG  
sig.FMG 
sig.FFS  
sig.FMS  
sig.GS  
sig.FFMS 
sig.FFMG 
all 

matrixtobe = c(sig.G, sig.GS, sig.FFG, sig.FMG, sig.FFMG, all,
  sig.GS, sig.S, sig.FFS, sig.FMS , sig.FFMS,all, 
  sig.FFG, sig.FFS, sig.FF, sig.FFM, sig.FF,all,
  sig.FMG, sig.FMS, sig.FFM, sig.FM, sig.FM,all,
  sig.FFMG, sig.FFMS, sig.FF, sig.FM, sig.FM,all
  )

sig.model = matrix(matrixtobe, ncol = 6, byrow = TRUE)
colnames(sig.model) = c("Glyph", "Sex", "Full F", "Full M", "Full F&M", "all")
rownames(sig.model) = c("Glyph", "Sex", "Full F", "Full M", "Full F&M")

# 5. plot ---- 
## * 5.1 cat plot ----

catplot.list = c()

for (site in selectedsite){
  
  sitetotest = subset(meth_unmethFilt, meth_unmethFilt$chrpos1==sitestokeep.list[site])
  
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
                               main.title = sitestokeep.list[site],
                               line.thickness =0.5,
                               pred.point.size = 2
  )
  
  ggsave(
    sprintf("./plot/%s_catplotfull.png", sitestokeep.list[site]),
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
allpval.full$X2 = as.factor(allpval.full$X2)

allpval.full[allpval.full==0]<-NA



((full_pval.plot = ggplot(allpval.full, aes(x=X1, color=X2, fill=X2))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    facet_wrap(~X2)+
    labs(title="p value distribution for \n F1/F2 and M1/M2 contrasts",
         x="p value")+
    scale_fill_discrete(labels = c("Female", "Male"))+
    scale_color_discrete(labels = c("Female", "Male"))+
    theme_minimal()
))


allpval.glyph[allpval.glyph==0]<-NA

((glyph_pval.plot = ggplot(allpval.glyph, aes(x=X1))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    xlab("p value")+
    theme_minimal()+
    ggtitle("p value distribution for treatment contrasts" )
))


allpval.sex[allpval.sex==0]<-NA
((sex_pval.plot = ggplot(allpval.sex, aes(x=X1))+
    geom_histogram(aes(y=..density..), position="identity", alpha=0.2)+
    geom_density(alpha=0.5)+
    xlab("p value")+
    ggtitle("p value distribution \n for male and female contrasts" )
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





# save ... ----

save(meth_unmethFilt,
     sitestokeep.list,
     file = "data_pip7.RData")

save.image("pipeline_7.RData")

