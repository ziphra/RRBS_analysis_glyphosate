# Introduction to linear mixed model 

A mixed model is a statistical model containing both fixed effects and random effects.

see [this tutorial about mixed model](https://ourcodingclub.github.io/tutorials/mixed-models/#what) or [this page](https://mfviz.com/hierarchical-models/) for better visualition

## Explore the data
One thing to start could be to plot the response variable against factors of interest: how the distribution looks?

#### scale the data
A good thing to do is to `scale ()` the data before proceeding so that they have a mean of zero (“centering”) and standard deviation of one (“scaling”). It ensures that the estimated coefficients are all on the same scale, making it easier to compare effect sizes: `dragons$bodyLength2 <- scale(dragons$bodyLength, center = TRUE, scale = TRUE)`

#### plot and color by variables
```
(colour_plot <- ggplot(dragons, aes(x = bodyLength, y = testScore, colour = mountainRange)) +
  geom_point(size = 2) +
  theme_classic() +
  theme(legend.position = "none"))
```

#### Run multiple analyses
```
(split_plot <- ggplot(aes(bodyLength, testScore), data = dragons) + 
  geom_point() + 
  facet_wrap(~ mountainRange) + # create a facet for each mountain range
  xlab("length") + 
  ylab("test score"))
```

## Mixed effects models
Lme4 will allow us to use all the data we have (higher sample size) and account for the correlations between data coming from all our measurments. 

### Fixed and random effects
The differences between fixed and random effect has little to do with the variable themselves but a lot with the research questions asked.

In broad terms, fixed effects are variables that we expect will have an effect on the dependent/response variable: they’re what you call explanatory variables in a standard linear regression. *(glyphosate exposition?)*

On the other hand, random effects are usually grouping factors for which we are trying to control. They are always categorical, as you can’t force R to treat a continuous variable as a random effect. A lot of the time we are not specifically interested in their impact on the response variable, but we know that they might be influencing the patterns we see. *(nest,batch?)*

You generally want your random effect to have at least five levels. So, for instance, if we wanted to control for the effects of dragon’s sex on intelligence, we would fit sex (a two level factor: male or female) as a fixed, not random, effect.

### Fit a random effect 
with the syntax `(1|variableName)`:
 
```
mixed.lmer <- lmer(testScore ~ bodyLength2 + (1|mountainRange), data = dragons)
   
summary(mixed.lmer)
```

```
Linear mixed model fit by REML ['lmerMod']
Formula: testScore ~ bodyLength2 + (1 | mountainRange)
   Data: dragons

REML criterion at convergence: 3985.6

Scaled residuals: 
    Min      1Q  Median      3Q     Max 
-3.4815 -0.6513  0.0066  0.6685  2.9583 

Random effects:
 Groups        Name        Variance Std.Dev.
 mountainRange (Intercept) 339.7    18.43   
 Residual                  223.8    14.96   
Number of obs: 480, groups:  mountainRange, 8

Fixed effects:
            Estimate Std. Error t value
(Intercept)  50.3860     6.5517   7.690
bodyLength2   0.5377     1.2750   0.422

Correlation of Fixed Effects:
            (Intr)
bodyLength2 0.000 
```
The random effect part tells how much variance we find amongts levels of grouping factors, plus the residual variance.    
The fixed effect part is very similar to a linear model output. 

We can see the variance for mountainRange = 339.7. Mountain ranges are clearly important: they explain a lot of variation. How do we know that? We can take the variance for the mountainRange and divide it by the total variance: `339.7/(339.7 + 223.8)  # ~60 %`

### Type of random effect 
#### Crossed random effect
An effect is crossed when the subjects have experienced several levels of that effect.

#### Nested random effects
For hierarchial models.

Let's imagine an experiment where we have 50 seedlings in each bed, with 10 control and 10 experimental beds. That’s 1000 seedlings altogether. And let’s say we went out collecting once in each season in each of the 3 years and on each plant, we measure the length of 5 leaves.

We could first add a random effect structure to account for the nesting effect, but also add the seasonal crossed effect like this: 
`leafLength ~ treatment + (1|Bed/Plant/Leaf) + (1|Season)`


To sum up: for nested random effects, the factor appears ONLY within a particular level of another factor (each site belongs to a specific mountain range and only to that range); for crossed effects, a given factor appears in more than one level of another factor (dragons appearing within more than one mountain range). Or you can just remember that if your random effects aren’t nested, then they are crossed! 

becareful of implicit vs explicit nesting.

`(1|mountainRange/site)` and `(1|mountainRange) + (1|mountainRange:site)` are equivalent. However, it is advisable to set out your variables properly and make sure nesting is stated explicitly within them, that way you don’t have to remember to specify the nesting.

##### Visualize the nesting in the data: 
```
(mm_plot <- ggplot(dragons, aes(x = bodyLength, y = testScore, colour = site)) +
      facet_wrap(~mountainRange, nrow=2) +   # a panel for each mountain range
      geom_point(alpha = 0.5) +
      theme_classic() +
      geom_line(data = cbind(dragons, pred = predict(mixed.lmer2)), aes(y = pred), size = 1) +  # adding predicted line from mixed model 
      theme(legend.position = "none",
            panel.spacing = unit(2, "lines"))  # adding space between panels
)
```
## Introducing random slopes 
A random-intercept model allows the intercept to vary for each level of the random effects, but keeps the slope constant among them.
But we can also fit a random-slope and a random-intercept model to our data. See [this page](https://mfviz.com/hierarchical-models/) to visualize.

To do so, we have to add the fixed variable into the random effect brackets: 

```
mixed.ranslope <- lmer(testScore ~ bodyLength2 + (1 + bodyLength2|mountainRange/site), data = dragons) 

summary(mixed.ranslope)
```

Plot with random slopes: 

```
(mm_plot <- ggplot(dragons, aes(x = bodyLength, y = testScore, colour = site)) +
      facet_wrap(~mountainRange, nrow=2) +   # a panel for each mountain range
      geom_point(alpha = 0.5) +
      theme_classic() +
      geom_line(data = cbind(dragons, pred = predict(mixed.ranslope)), aes(y = pred), size = 1) +  # adding predicted line from mixed model 
      theme(legend.position = "none",
            panel.spacing = unit(2, "lines"))  # adding space between panels
)
```

# Introduction to generalized mixed model 
[FAQ](https://bbolker.github.io/mixedmodels-misc/glmmFAQ.html)

