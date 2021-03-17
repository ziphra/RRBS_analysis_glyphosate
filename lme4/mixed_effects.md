# Mixed effects modelling and multi-model inference in ecology
Zhang, Y., Baheti, S., Sun, Z., 2016. Statistical method evaluation for differentially methylated CpGs in base resolution next-generation DNA sequencing data. Brief Bioinform bbw133. https://doi.org/10.1093/bib/bbw133

Biological dataset are often clustered in non independant observational unites, making difficult their analysis. For example, we might expect the measurements from a statistical units to be more similar than measurements from different units.

Linear mixed effects models (LMMs) allow to take fixed and random effects as predictor variables.

## Understanding fixed and random effect
The first step of the modelling process is to defined the random and the fixed effects.

### Fixed and random effects
The differences between fixed and random effect has little to do with the variable themselves but a lot with the research questions asked.

In broad terms, fixed effects are variables that we expect will have an effect on the dependent/response variable: they’re what you call explanatory variables in a standard linear regression. *(glyphosate exposition?)*

On the other hand, random effects are usually grouping factors for which we are trying to control. They are always categorical, as you can’t force R to treat a continuous variable as a random effect. A lot of the time we are not specifically interested in their impact on the response variable, but we know that they might be influencing the patterns we see. *(sex,nest,batch?)*

You generally want your random effect to have at least five levels. So, for instance, if we wanted to control for the effects of dragon’s sex on intelligence, we would fit sex (a two level factor: male or female) as a fixed, not random, effect.

### Controlling for non-independence among data points
Complex biological data
sets often contain nested and/or hierarchical structures such as repeat measurements from individuals within and across units of time.   
**Random effect** allow to controll for the non-independance of the data, by constraining the intercept, or the slope.   

**Example** *if we had measured animals from multiple sampling sites, we might wish to fit ‘sampling site’ as a random intercept, and estimate a common slope (change in breeding success) for body mass across all sampling sites by fitting it as a fixed effect:*   
`M3 <- glmer(successful.breed ∼ body.mass + (1|sample.site), family=binomial)`


*Conversely, we might wish to test the hypothesis that the strength of the effect (slope) of body mass on breeding success varies depending on the sampling location i.e. the change in breeding success for a 1 unit change in body mass is not consistent across groups. Here, ‘body mass’ is specified as a random slope by adding it to the random effects structure. This model estimates a random intercept, random slope, and the correlation between the two and also the fixed effect of body mass:*   
`M4 <- glmer(successful.breed ∼ body.mass + (body.mass|sample.site), family=binomial)`

It is recommended to fit both random slopes and intercepts when possible.

### Improving the accuracy of parameter estimation
Random effect models use data from all the groups to estimate the mean and variance of the global distribution of group means.  
Assuming all group means are drawn from a common distribution causes the estimates of their means to drift towards the global mean group. 

### Estimating variance components
In some cases, the variation among groups can be of interest. 

**Example:** *imagine we had measured the clutch masses of 30 individual birds, each of which had produced five clutches (n = 150). We might be interested in asking whether different females tend to produce consistently different clutch masses (high variance for clutch mass among female). To do so, we might fit an intercept-only model with Clutch Mass as the response variable and a Gaussian error structure:*   
`Model <- lmer(ClutchMass ∼ 1 + (1|FemaleID)`

By fitting individual ‘FemaleID’ as a random intercept term in the LMM, we estimate the among-female variance in our trait of interest, while differences among individuals can be obtained by fitting individual ID as a fixed effect...

## Consideration when fixing random effects
For the variance estimation to be robust, at least 5 level are recquired to fix a random effect.   
Models can be unstable if there is too many missing data.   
It is also difficult to decide the significance or the importance of the differences of variances between groups.

## Deciding model structure for GLMM 
GLM makes several statistical assumptiuns, that are sometimes violated. The model must thus be specified to ensure its robustness, or the variable response transformed.    
**Example:** *an analytical goal may be to quantify differences in mean mass between males and females, but if
the variance in mass for one sex is greater than the other, the assumption of homogeneity of variance is violated*   

### Choosing random effects I: crossed or nested?
**Example:** *Imagine a researcher was interested in understanding the factors affecting the clutch mass of a passerine bird. They have a study population spread across five separate woodlands, each containing 30 nest boxes. Every week during breeding they measure the foraging rate of females at feeders, and measure their subsequent clutch mass. Some females have multiple clutches in a season and contribute multiple data points. Here, female ID is said to be nested within woodland: each woodland contains multiple females unique to that woodland (that never move among woodlands). The nested random effect controls for the fact that (i) clutches from the same female are not independent, and (ii) females from the same woodland may have clutch masses more similar to one another than to females from other woodlands*     
`Clutch Mass ∼ Foraging Rate + (1|Woodland/Female ID)`

*Now imagine that this is a long-term study, and the researcher returns every year for five years to continue with measurements. Here it is appropriate fit year as a crossed random effect because every woodland appears multiple times in every year of the dataset, and females that survive from one year to the next will also appear in multiple years.*   
`Clutch Mass ∼ Foraging Rate + (1|Woodland/Female ID)+ (1|Year)`

A model specified as ∼(1| Woodland) + (1|FemaleID) would be identical to the model above.

To sum up: for nested random effects, the factor appears ONLY within a particular level of another factor (each female belongs to a specific sites and only to that sites); for crossed effects, a given factor appears in more than one level of another factor (females appearing within more than one year). Or you can just remember that if your random effects aren’t nested, then they are crossed!

### Choosing random effects II: random slopes
Fitting random slopes in ecology studies is not that common. However, there is growing evidence that it should. One should try to always fit the maximal complexity of random effects structure   

If fitting a random slope model including correlations between intercepts and slopes, always inspect the intercept-slope correlation coefficient in the variance/covariance summary returned by packages like lme4 to look for evidence of perfect correlations, indicative of insufficient data to estimate the model.

### Choosing fixed effect predictors and interactions
Consider effects with rigorous a priori consideration of the system under study.

### How complex should my global model be?


## Quantifying GLMM fit and performance
The global model is usually the best. 

Model fit and model adequacy are two separate but equally important traits that must be assessed and reported.

### Inspection of residuals and linear model assumptions

**Examine plots of residuals versus fitted values for the entire model, as well as model residuals versus all explanatory variables to look for patterns:**  
`plot(glmer.model)`


**Assumption of normality of deviations of the conditional means of the random effects from the global intercept:**   
`qqnorm(resid(glmer.model))`

### Overdispersion
For generalized mixed models (GLMMs)(e.g. Poisson, Binomial), the variance of the data can be greater than predicted by the error structure of the model: it suggests the model is a bad fit. It can increases type I errors because standard errors are underestimated. See script and R package Squid. 

### R<sup>2</sup>
In a linear modelling context, R2 gives a measure of the proportion of explained variance in the model, and is an intuitive metric for assessing model fit. But not for GLMM 

### Stability of variance components and testing significance of random effects

## Model selection 
### Stepwise selection 
It is the comparaison of a candidate model to a *null model* and test the null-hypothesis significance.

### Information-theory and multi-model inference 
Difference among models in AIC should be representative in relative differences in KLD (a measure of the relative amount of information lost when a given model approximates the true data-generating process), and the model with the lowest AIC should lose the least information and be the best model in that it optimises the trade-off between fit and complexity.
