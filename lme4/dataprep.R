library(tidyverse)
library(tidyfast, lib.loc = "/scratch/project_2003821/lme4/")
library(readr)


setwd("/scratch/project_2003821/lme4")
load(file = "lme4.RData")


# Dataprep ----
# * Load ----
# load methylation information retrieved from the .cov files 
datamc = fixed_chr_pos_ctk_whead_no0_MS_mc <- read_delim("./final_cov/fixed_chr_pos_ctk_whead_no0_MS_mc.txt", 
                                                         "\t", escape_double = FALSE, trim_ws = TRUE)

datauc = fixed_chr_pos_ctk_whead_no0_MS_mc <- read_delim("./final_cov/fixed_chr_pos_ctk_whead_no0_MS_uc.txt", 
                                                         "\t", escape_double = FALSE, trim_ws = TRUE)

datamp = fixed_chr_pos_ctk_whead_no0_MS_mc <- read_delim("./final_cov/fixed_chr_pos_ctk_whead_no0_MS_mp.txt", 
                                                         "\t", escape_double = FALSE, trim_ws = TRUE)


# load sample information 
sampleID_name_file_sex_fam <- read_csv("sampleID_name_file_sex_fam_ID12.csv")
sampleID_name_file_sex_fam$Fam = as.factor(sampleID_name_file_sex_fam$Fam)
sampleID_name_file_sex_fam$cond = as.factor(sampleID_name_file_sex_fam$cond)
sampleID_name_file_sex_fam$age = as.factor(sampleID_name_file_sex_fam$age)

# load relatedness matrix  
relatedness <- read_csv("relatedness.csv")


# * From wide to long ----
datamc_long = dt_pivot_longer(
  datamc, 
  cols = -chrpos1, 
  names_to = "file", 
  values_to = "meth_count"
)

datauc_long = dt_pivot_longer(
  datauc, 
  cols = -chrpos1, 
  names_to = "file", 
  values_to = "unmeth_count"
)


datamp_long = dt_pivot_longer(
  datamp, 
  cols = -chrpos1, 
  names_to = "file", 
  values_to = "meth_perc"
)

# Add sample information to the dataframes created  
merged_datauc <- merge(datauc_long,sampleID_name_file_sex_fam,by="file")
merged_datamc <- merge(datamc_long,sampleID_name_file_sex_fam,by="file")
merged_datamp <- merge(datamp_long,sampleID_name_file_sex_fam,by="file")


# Plotting... ----

#* plot every sites ----
# mean % per site, in terms of treatment and age
agg_mean_site_cond_age_mp = aggregate(merged_datamp$meth_perc, list(merged_datamp$chrpos1, merged_datamp$cond, merged_datamp$age), mean)

sp_mean_cond_age_mp = ggplot(aes(Group.1, x), data = agg_mean_site_cond_age_mp) + 
  geom_point() + 
  facet_wrap(~ Group.2+Group.3,scales = "free")+
  theme(axis.text.x = element_blank())


# ggsave not working with the server (X11...)
ggsave(
  "sp_mean_cond_age_mp.png",
  device = png(),
  plot = sp_mean_cond_age_mp,
  scale = 1,
  width = 400,
  height = 300,
  units = "cm",
  dpi = 72,
  limitsize = FALSE,
)


# * colour plot, mean per batch and cond ----
agg_mean_batch_mp = aggregate(merged_datamp$meth_perc, list(merged_datamc$batch), mean)
agg_mean_batch_cond_mp = aggregate(merged_datamp$meth_perc, list(merged_datamp$batch, merged_datamp$cond), mean)

plot_mean_batch_cond_mp <- ggplot(agg_mean_batch_cond_mp, aes(x = as.factor(Group.2), y = x, colour = Group.1, group = Group.1)) +
  geom_point(size = 1) +
  geom_line() +
  theme_classic() +
  scale_color_gradientn(colours = rainbow(5))+
  theme(legend.position = "none")
plot_mean_batch_cond_mp

ggsave(
  "plot_mean_batch_cond_mp.png",
  device = png(),
  plot = plot_mean_batch_cond_mp,
  scale = 1,
  width = 10,
  height = 10,
  units = "cm",
  dpi = 300,
  limitsize = FALSE,
)


# * mean per batch/cond/age facet grid ----
agg_mean_batch_cond_age_mp = aggregate(merged_datamp$meth_perc, list(merged_datamp$batch, merged_datamp$cond,merged_datamp$age), mean)

plot_mean_batch_cond_age_mp <- ggplot(agg_mean_batch_cond_age_mp, aes(x = as.factor(Group.3), y = x, colour = Group.1, group = Group.1)) +
  geom_point(size = 1) +
  geom_line() +
  theme_classic() +
  scale_color_gradientn(colours = rainbow(5))+
  facet_wrap(~ Group.2)+
  plot_mean_batch_cond_age_mp

ggsave(
  "plot_mean_batch_cond_age_mp.png",
  device = png(),
  plot = plot_mean_batch_cond_age_mp,
  scale = 1,
  width = 10,
  height = 10,
  units = "cm",
  dpi = 300,
  limitsize = FALSE,
)



save.image("lme4.RData")


