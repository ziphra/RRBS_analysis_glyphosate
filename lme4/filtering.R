library(readr)
library(lme4qtl)
library(lme4)
# Filtering sites that have at least 5% differences between pairwise comparison 

meth_mean.persite = aggregate(merged_datamp$meth_perc, 
                              list(merged_datamp$chrpos1, merged_datamp$cond, merged_datamp$age, merged_datamp$sex), mean)


colnames(meth_mean.persite) <- c("chrpos1", "cond", "age", "sex", "x")

write.table(meth_mean.persite, file = "meth_mean_persite.txt", sep = "\t",row.names = FALSE)


sites.list = unique(meth_mean.persite$chrpos1)
sitestokeep.list = c() 

for (site in 1:length(sites.list)){
  onesite = subset(meth_mean.persite, meth_mean.persite$chrpos1==sites.list[site])
  
  if (onesite[((onesite$cond==1)&(onesite$age==7)&(onesite$sex=="F")),5] - onesite[((onesite$cond==2)&(onesite$age==7)&(onesite$sex=="F")),5] > 5){
    sitestokeep.list = c(sitestokeep.list,onesite[1,1])
    } else if (onesite[((onesite$cond==1)&(onesite$age==12)&(onesite$sex=="F")),5] - onesite[((onesite$cond==2)&(onesite$age==12)&(onesite$sex=="F")),5] > 5){
      sitestokeep.list = c(sitestokeep.list,onesite[1,1])
    } else if (onesite[((onesite$cond==1)&(onesite$age==7)&(onesite$sex=="M")),5] - onesite[((onesite$cond==2)&(onesite$age==7)&(onesite$sex=="M")),5] > 5){
      sitestokeep.list = c(sitestokeep.list,onesite[1,1])
  } else if (onesite[((onesite$cond==1)&(onesite$age==12)&(onesite$sex=="M")),5] - onesite[((onesite$cond==2)&(onesite$age==12)&(onesite$sex=="M")),5] > 5){
    sitestokeep.list = c(sitestokeep.list,onesite[1,1])
  }
}

save.image("lme4.RData")