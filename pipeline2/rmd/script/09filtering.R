load(file="09filtered.RData")
load(file="09datalme4.RData")
library(dplyr)


meth_mean.persite = aggregate(merged_datamp$meth_perc, 
                              list(merged_datamp$chrpos1, merged_datamp$cond, merged_datamp$age, merged_datamp$sex), mean)


colnames(meth_mean.persite) <- c("chrpos1", "cond", "age", "sex", "x")



sites.list = unique(meth_mean.persite$chrpos1)
sitestokeepF7 = c("zero") 
sitestokeepF12 = c("zero") 
sitestokeepM7 = c("zero") 
sitestokeepM12 = c("zero") 

  
for (site in 1:length(sites.list)){
  onesite = subset(meth_mean.persite, meth_mean.persite$chrpos1==sites.list[site])
  
  subsiteF7 = subset(onesite, age == 7 & sex == "F")
  if (abs(subsiteF7[1,5]-subsiteF7[2,5]) >= 10){
    sitestokeepF7 = c(sitestokeepF7,subsiteF7[1,1])
  }
  
  subsiteF12 = subset(onesite, age == 12 & sex == "F")
  if (abs(subsiteF12[1,5]-subsiteF12[2,5]) >= 10){
    sitestokeepF12 = c(sitestokeepF12,subsiteF12[1,1])
  }
  
  subsiteM12 = subset(onesite, age == 12 & sex == "M")
  if (abs(subsiteM12[1,5]-subsiteM12[2,5]) >= 10){
    sitestokeepM12 = c(sitestokeepM12,subsiteM12[1,1])
  }
  
  subsiteM7 = subset(onesite, age == 7 & sex == "M")
  if (abs(subsiteM7[1,5]-subsiteM7[2,5]) >= 10){
    sitestokeepM7 = c(sitestokeepM7,subsiteM7[1,1])
  }
  
}
  
# remove first element of the list 
sitestokeepF7 = (unique(sitestokeepF7[-1]))
sitestokeepF12 = (unique(sitestokeepF12[-1])) 
sitestokeepM7 = (unique(sitestokeepM7[-1]))
sitestokeepM12 = (unique(sitestokeepM12[-1])) 

allsites = c(sitestokeepF7, sitestokeepF12, sitestokeepM7, sitestokeepM12) # 12722
allsites = unique(allsites) # 8731
allsites7 = unique(c(sitestokeepF7, sitestokeepM7)) #5231
allsites12 = unique(c(sitestokeepF12, sitestokeepM12)) #6262


meth_unmeth = cbind(merged_datamc, merged_datauc$unmeth_count)
meth_unmethFilt7 = filter(meth_unmeth, chrpos1%in%allsites7)
meth_unmethFilt12 = filter(meth_unmeth, chrpos1%in%allsites12)


save(sitestokeepF7,
     sitestokeepF12,
     sitestokeepM7,
     sitestokeepM12,
     meth_unmethFilt7,
     meth_unmethFilt12,
     file="09datalme4.RData")  



save.image("09filtered.RData")
