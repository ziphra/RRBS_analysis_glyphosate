library(dplyr)
library(ggplot2)
library(tibble)
load(file = "warningsites12.RData")
`%notin%` <- Negate(`%in%`)

# issued  ----- #530
# convergence issues #306
convergence_war = short_warning.full[grep("Model failed to converge", short_warning.full)]
convergence_sites = (names(convergence_war))

# singular issues #206
singular_war = short_warning.full[grep("Singular", short_warning.full)]
singular.sites = (names(singular_war))

# unable issues #17
unable_war = short_warning.full[grep("unable", short_warning.full)]
unable.sites = (names(unable_war))

# F ----
# issues in pvFull list ----- 
conv.in = filter(pv_fullF, rownames(pv_fullF)%in%convergence_sites) #46
singular.in = filter(pv_fullF, rownames(pv_fullF)%in%singular.sites) #206
unable.in = filter(pv_fullF, rownames(pv_fullF)%in%unable.sites) #17


# sig sites from combp with warnings
conv.in_sigF = filter(fF_sites12R, V1%in%convergence_sites) #30
sing.in_sigF = filter(fF_sites12R, V1%in%singular.sites) #7
unable.in_sigF = filter(fF_sites12R, V1%in%unable.sites) #0


# plot these sites ----
# filter data with ff12

#conv
sitesconv = filter(merged_datamp, chrpos1%in%conv.in_sigF$V1, age==12, sex=="F")

# calculate meth mean and sd /site /cond
means = aggregate(sitesconv$meth_perc, list(sitesconv$chrpos1, sitesconv$cond), mean)
stddev = aggregate(sitesconv$meth_perc, list(sitesconv$chrpos1, sitesconv$cond), sd)
toplot.conv = cbind(stddev,means$x)
colnames(toplot.conv) = c("chrpos1","cond","sd","means")


((
  ff12conv = ggplot(aes(chrpos1, means, colour=cond), data = toplot.conv) + 
    geom_point()+
    geom_errorbar(aes(ymin=means-sd, ymax=means+sd), width=.2, position=position_dodge(0.05))+
    theme(legend.title = element_blank())+
    theme(axis.text.x = element_text(size=5, angle=30, hjust = 1))+
    xlab("position")+
    ylab("methylation%")
))

#sing
sites.sing = filter(merged_datamp, chrpos1%in%sing.in_sigF$V1, age==12, sex=="F")

means.sing = aggregate(sites.sing$meth_perc, list(sites.sing$chrpos1, sites.sing$cond), mean)
stddev.sing = aggregate(sites.sing$meth_perc, list(sites.sing$chrpos1, sites.sing$cond), sd)
toplot.sing = cbind(stddev.sing,means.sing$x)
colnames(toplot.sing) = c("chrpos1","cond","sd","means")

((
  ff12sing = ggplot(aes(chrpos1, means, colour=cond), data = toplot.sing) + 
    geom_point()+
    geom_errorbar(aes(ymin=means-sd, ymax=means+sd), width=.2, position=position_dodge(0.05))+
    theme(legend.position='none')+
    theme(legend.title = element_blank())+
    theme(axis.text.x = element_text(size=5, angle=30, hjust = 1))+
    xlab("position")+
    ylab("methylation%")
))

# una 
#no sites 

# M ----
# issues in pvFull list ----- 
conv.inM = filter(pv_fullM, rownames(pv_fullM)%in%convergence_sites) #48
singular.inM = filter(pv_fullM, rownames(pv_fullM)%in%singular.sites) #206
unable.inM = filter(pv_fullM, rownames(pv_fullM)%in%unable.sites) #17


# sig sites from combp with warnings
conv.in_sigM = filter(fM_sites12R, V1%in%convergence_sites) #30
sing.in_sigM = filter(fM_sites12R, V1%in%singular.sites) #8
unable.in_sigM = filter(fM_sites12R, V1%in%unable.sites) #0


# plot these sites ----
# filter data with fm12

#conv
sitesconvM = filter(merged_datamp, chrpos1%in%conv.in_sigM$V1, age==12, sex=="M")

# calculate meth mean and sd /site /cond
means = aggregate(sitesconvM$meth_perc, list(sitesconvM$chrpos1, sitesconvM$cond), mean)
stddev = aggregate(sitesconvM$meth_perc, list(sitesconvM$chrpos1, sitesconvM$cond), sd)
toplot.convM = cbind(stddev,means$x)
colnames(toplot.convM) = c("chrpos1","cond","sd","means")


((
  fm12conv = ggplot(aes(chrpos1, means, colour=cond), data = toplot.convM) + 
    geom_point()+
    geom_errorbar(aes(ymin=means-sd, ymax=means+sd), width=.2, position=position_dodge(0.05))+
    theme(legend.title = element_blank())+
    theme(axis.text.x = element_text(size=5, angle=30, hjust = 1))+
    xlab("position")+
    ylab("methylation%")
))


sites.singM = filter(merged_datamp, chrpos1%in%sing.in_sigM$V1, age==12, sex=="M")

means.singM = aggregate(sites.singM$meth_perc, list(sites.singM$chrpos1, sites.singM$cond), mean)
stddev.singM = aggregate(sites.singM$meth_perc, list(sites.singM$chrpos1, sites.singM$cond), sd)
toplot.singM = cbind(stddev.singM,means.singM$x)
colnames(toplot.singM) = c("chrpos1","cond","sd","means")

((
  fm12sing = ggplot(aes(chrpos1, means, colour=cond), data = toplot.singM) + 
    geom_point()+
    geom_errorbar(aes(ymin=means-sd, ymax=means+sd), width=.2, position=position_dodge(0.05))+
    theme(legend.position='none')+
    theme(legend.title = element_blank())+
    theme(axis.text.x = element_text(size=5, angle=30, hjust = 1))+
    xlab("position")+
    ylab("methylation%")
))





df <- enframe(short_warning.full)
test = filter(df, df$name%notin%convergence_sites
                          &df$name%notin%singular.sites
                          &df$name%notin%unable.sites)




# new pv full list -----
newfF_pv_fullF12 = filter(pv_fullF, rownames(pv_fullF)%notin%df$name)

newfM_pv_fullM12 = filter(pv_fullM, rownames(pv_fullM)%notin%df$name)




# save -----


write.table(newfF_pv_fullF12, file = "newfF_pv_fullF12.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)


write.table(newfM_pv_fullM12, file = "newfM_pv_fullM12.txt", sep = "\t",
            row.names = TRUE, col.names = FALSE)







#################

save(pv_fullF,
     pv_fullM,
     short_warning.full,
     fF_sitesR,
     fM_sitesR,
     merged_datamp,
     fm12unableM,
     fm12sing,
     fm12conv,
     ff12sing,
     ff12conv,
     newfF_pv_fullF12,
     newfM_pv_fullM12,
     file = "warningsites12.RData")


save(fm12conv,
     fm12sing,
     ff12sing,
     ff12conv,
     conv.in,
     singular.in,
     unable.in,
     singular.inM,
     unable.inM,
     conv.inM,
     file = "warning_rmd.RData")


