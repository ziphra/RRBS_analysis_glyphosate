# Lme4 

As methylation count are binary data (the outcome is count of 0 and 1) we will use the binomial distribution, i.e. the logistic regression model.

## Find the proper design 
### Test models 
  
**Predict the effect of the family on the data: intercept model**    
We try to look for the effect of familly on the data prediction. Familly is fitted as a random effect    
         
```  
RRBS.Int <- glmer(cbind(df_meth_unmeth) ~ 1|Fam, data = input.df, family="binomial")
```

**Predict the effect of sex on the data:**
Now, let's see how sex and methylation are correlated, while still correcting for the familly effect. Sex is fitted as a fixed effect. 

```
RRBS.SexEffect <-glmer(cbind(input.df$meth,input.df$unmeth) ~ sex + 1|family, data = input.df, family="binomial")
```
**Predict the effect of the treatment:**    
Let's see if methylation and treatment are correlated, while still correcting for family. The treatment is fitted as a fixed effect. 

``` 
RRBS.GlyphEffect <-glmer(cbind(input.df$meth,input.df$unmeth) ~ cond + 1|family, family="binomial") 
```
How it goes when we account for all of the measurments?

```
RRBS.Interaction <-glmer(cbind(input.df$meth,input.df$unmeth) ~ sex*cond + 1|family, family="binomial") 
```
### lme4 convergence warnings: troubleshooting
see this [page](https://rstudio-pubs-static.s3.amazonaws.com/33653_57fc7b8e5d484c909b615d8633c01d51.html)

### Which model is the best?
#### AIC 
The Akaike information criterion (AIC) is a mathematical method for evaluating how well a model fits the data it was generated from. AIC is used to compare different possible models and determine which one is the best fit for the data. AIC is calculated from:

- the number of independent variables used to build the model.
the maximum likelihood estimate of the model (how well the model reproduces the data).
- The best-fit model according to AIC is the one that explains the greatest amount of variation using the fewest possible independent variables.

```
AIC.list <- c(AIC(RRBS.Int), AIC(RRBS.SexEffect), AIC(RRBS.GlyphEffect), AIC(RRBS.Interaction))
```

#### Anova 

```
ModComp <- anova(RRBS.Int, RRBS.SexEffect, RRBS.GlyphEffect, RRBS.Interaction)
```

##### Results without relatedness matrix:  

```
Data: meth_unmethFilt
Models:
tRRBS.Int: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ 1 + (1 | Fam)
tRRBS.SexEffect: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex + (1 | Fam)
tRRBS.GlyphEffect: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ cond + (1 | Fam)
tRRBS.Interaction: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex * cond + (1 | Fam)
                  npar      AIC      BIC    logLik deviance     Chisq Df Pr(>Chisq)    
tRRBS.Int            2 41771889 41771913 -20885942 41771885                            
tRRBS.SexEffect      3 41771860 41771895 -20885927 41771854    31.305  1  2.205e-08 ***
tRRBS.GlyphEffect    3 41736599 41736635 -20868297 41736593 35260.261  0               
tRRBS.Interaction    5 41735412 41735472 -20867701 41735402  1190.902  2  < 2.2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

Regarding the p value and the AIC, the global model `tRRBS.Interaction` seems to explain the most the data.

**Models summary:**


``` 
> tsumInt
Generalized linear mixed model fit by maximum likelihood (Adaptive Gauss-Hermite Quadrature, nAGQ = 0) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ 1 + (1 |      Fam)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41771889  41771913 -20885942  41771885   1117148 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-170.256   -4.030   -0.634    3.100  154.230 

Random effects:
 Groups Name        Variance Std.Dev.
 Fam    (Intercept) 0.002163 0.0465  
Number of obs: 1117150, groups:  Fam, 17

Fixed effects:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.09034    0.01128  -8.008 1.16e-15 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

```
> tsumSexEffect
Generalized linear mixed model fit by maximum likelihood (Adaptive Gauss-Hermite Quadrature, nAGQ = 0) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex + (1 |      Fam)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41771860  41771895 -20885927  41771854   1117147 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-170.377   -4.030   -0.634    3.099  154.161 

Random effects:
 Groups Name        Variance Std.Dev.
 Fam    (Intercept) 0.002165 0.04653 
Number of obs: 1117150, groups:  Fam, 17

Fixed effects:
              Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.0920240  0.0112915  -8.150 3.64e-16 ***
sexM         0.0025766  0.0004605   5.595 2.21e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
     (Intr)
sexM -0.027
```
```
> tsumGlyphEffect
Generalized linear mixed model fit by maximum likelihood (Adaptive Gauss-Hermite Quadrature, nAGQ = 0) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ cond +      (1 | Fam)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41736599  41736635 -20868297  41736593   1117147 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-172.486   -4.025   -0.631    3.098  152.970 

Random effects:
 Groups Name        Variance Std.Dev.
 Fam    (Intercept) 0.002382 0.04881 
Number of obs: 1117150, groups:  Fam, 17

Fixed effects:
              Estimate Std. Error  z value Pr(>|z|)    
(Intercept) -0.0379181  0.0118426   -3.202  0.00137 ** 
cond2       -0.0973935  0.0005185 -187.831  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
      (Intr)
cond2 -0.024
```
```
> tsumInteraction
Generalized linear mixed model fit by maximum likelihood (Adaptive Gauss-Hermite Quadrature, nAGQ = 0) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex * cond +      (1 | Fam)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41735412  41735472 -20867701  41735402   1117145 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-171.875   -4.027   -0.632    3.099  153.314 

Random effects:
 Groups Name        Variance Std.Dev.
 Fam    (Intercept) 0.00248  0.0498  
Number of obs: 1117150, groups:  Fam, 17

Fixed effects:
              Estimate Std. Error  z value Pr(>|z|)    
(Intercept) -0.0275377  0.0120922   -2.277   0.0228 *  
sexM        -0.0125985  0.0006110  -20.619  < 2e-16 ***
cond2       -0.0966928  0.0007502 -128.889  < 2e-16 ***
sexM:cond2  -0.0074858  0.0009179   -8.156 3.47e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
           (Intr) sexM   cond2 
sexM       -0.035              
cond2      -0.034  0.563       
sexM:cond2  0.019 -0.638 -0.708

```

##### Results with relatedness matrix:    
The matrix need to be a sparse matrix object. 

```
Data: meth_unmethFilt
Models:
qtRRBS.Int: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ 1 + (1 | 
qtRRBS.Int:     ID12)
qtRRBS.SexEffect: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex + (1 | 
qtRRBS.SexEffect:     ID12)
qtRRBS.GlyphEffect: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ cond + 
qtRRBS.GlyphEffect:     (1 | ID12)
qtRRBS.Interaction: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex * cond + 
qtRRBS.Interaction:     (1 | ID12)
                   npar      AIC      BIC    logLik deviance  Chisq Df Pr(>Chisq)
qtRRBS.Int            2 41656105 41656129 -20828051 41656101                     
qtRRBS.SexEffect      3 41656107 41656143 -20828051 41656101 0.0153  1     0.9016
qtRRBS.GlyphEffect    3 41656098 41656133 -20828046 41656092 9.5225  0           
qtRRBS.Interaction    5 41656102 41656161 -20828046 41656092 0.0124  2     0.9938
```

**Models summary:**

```
> qtsumInt
Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ 1 + (1 |      ID12)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41656105  41656129 -20828051  41656101   1117148 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-169.957   -4.037   -0.648    3.080  154.400 

Random effects:
 Groups Name        Variance Std.Dev.
 ID12   (Intercept) 0.008429 0.09181 
Number of obs: 1117150, groups:  ID12, 50

Fixed effects:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.08209    0.01760  -4.664 3.11e-06 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

```
> qtsumSexEffect
Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex + (1 |      ID12)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41656107  41656143 -20828051  41656101   1117147 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-169.957   -4.037   -0.648    3.080  154.400 

Random effects:
 Groups Name        Variance Std.Dev.
 ID12   (Intercept) 0.008428 0.0918  
Number of obs: 1117150, groups:  ID12, 50

Fixed effects:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.083549   0.018020  -4.636 3.54e-06 ***
sexM         0.002537   0.017181   0.148    0.883    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
     (Intr)
sexM -0.420
```
```
> qtsumGlyphEffect
Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ cond +      (1 | ID12)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41656098  41656133 -20828046  41656092   1117147 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-169.958   -4.037   -0.648    3.080  154.400 

Random effects:
 Groups Name        Variance Std.Dev.
 ID12   (Intercept) 0.006964 0.08345 
Number of obs: 1117150, groups:  ID12, 50

Fixed effects:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.05054    0.01660  -3.044 0.002335 ** 
cond2       -0.06035    0.01559  -3.871 0.000109 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
      (Intr)
cond2 -0.398
```
```
> qtsumInteraction
Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
 Family: binomial  ( logit )
Formula: cbind(meth_unmethFilt$meth, meth_unmethFilt$unmeth) ~ sex * cond +      (1 | ID12)
   Data: meth_unmethFilt

      AIC       BIC    logLik  deviance  df.resid 
 41656102  41656161 -20828046  41656092   1117145 

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-169.958   -4.037   -0.648    3.080  154.400 

Random effects:
 Groups Name        Variance Std.Dev.
 ID12   (Intercept) 0.006961 0.08343 
Number of obs: 1117150, groups:  ID12, 50

Fixed effects:
              Estimate Std. Error z value Pr(>|z|)   
(Intercept) -0.0518888  0.0206204  -2.516  0.01186 * 
sexM         0.0022945  0.0193068   0.119  0.90540   
cond2       -0.0600904  0.0196579  -3.057  0.00224 **
sexM:cond2  -0.0004181  0.0234606  -0.018  0.98578   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Correlation of Fixed Effects:
           (Intr) sexM   cond2 
sexM       -0.496              
cond2      -0.462  0.320       
sexM:cond2  0.280 -0.548 -0.558
```


## Plot model 

