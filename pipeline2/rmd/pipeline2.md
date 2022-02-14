Pipeline.2 Results
================
Euphrasie
10/1/2021

## Filtering

See code [here](./script/09filtering.R). Sites having a difference in
their methylation level of at least 10% between control and GBH exposure
inside each experimental groups (F7, M7, F12, M12) were kept.

## Pipeline

See [pipeline 2](./script/pipeline2.R). 3 models were run at 7 and 52
weeks old.

### Full model

Same as before

``` r
  full <-  relmatGlmer(cbind(sitetotest$meth_count,sitetotest$unmeth_count) 
                       ~ sex*cond + (1|ID12), data = sitetotest, 
                       relmat = list(ID12 = relatedness), 
                       family="binomial",
                       optimizer="bobyqa"
  )
```

### Glyph Effect

This model was run independently on each sex groups. Sex is no longer a
fixed effect.

``` r
  GlyphEffect <-  relmatGlmer(cbind(sitetotestF7$meth_count,sitetotestF7$unmeth_count) 
                              ~ cond + (1|ID12), data = sitetotestF7,
                              relmat = list(ID12 = relatedness),
                              family="binomial",
                              optimizer="bobyqa"
  )
```

## Results

### warnings

<table>
<caption>
warnings, 7 weeks
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
Glyph F
</th>
<th style="text-align:right;">
Glyph M
</th>
<th style="text-align:right;">
Full
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
‘?isSingular’
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:right;">
5
</td>
</tr>
<tr>
<td style="text-align:left;">
‘unable to evaluate scaled gradient’
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
5
</td>
</tr>
<tr>
<td style="text-align:left;">
’Model failed to converge
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
67
</td>
</tr>
<tr>
<td style="text-align:left;">
all
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
43
</td>
<td style="text-align:right;">
77
</td>
</tr>
</tbody>
</table>
<table>
<caption>
warnnings, 52 weeks
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
Glyph F
</th>
<th style="text-align:right;">
Glyph M
</th>
<th style="text-align:right;">
Full
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
‘?isSingular’
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
6
</td>
</tr>
<tr>
<td style="text-align:left;">
‘unable to evaluate scaled gradient’
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
4
</td>
</tr>
<tr>
<td style="text-align:left;">
’Model failed to converge
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
41
</td>
<td style="text-align:right;">
86
</td>
</tr>
<tr>
<td style="text-align:left;">
all
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
96
</td>
</tr>
</tbody>
</table>

### significant sites

<table>
<caption>
significant sites count, 7 weeks
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
Glyph F
</th>
<th style="text-align:right;">
Glyph M
</th>
<th style="text-align:right;">
Full
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
sites with p.value &lt; .05
</td>
<td style="text-align:right;">
516
</td>
<td style="text-align:right;">
727
</td>
<td style="text-align:right;">
1942
</td>
</tr>
<tr>
<td style="text-align:left;">
without sites issued warnings
</td>
<td style="text-align:right;">
495
</td>
<td style="text-align:right;">
684
</td>
<td style="text-align:right;">
1808
</td>
</tr>
</tbody>
</table>
<table>
<caption>
significant sites count, 52 weeks
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
Glyph F
</th>
<th style="text-align:right;">
Glyph M
</th>
<th style="text-align:right;">
Full
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
sites with p.value &lt; .05
</td>
<td style="text-align:right;">
835
</td>
<td style="text-align:right;">
801
</td>
<td style="text-align:right;">
2277
</td>
</tr>
<tr>
<td style="text-align:left;">
without sites issued warnings
</td>
<td style="text-align:right;">
806
</td>
<td style="text-align:right;">
759
</td>
<td style="text-align:right;">
2246
</td>
</tr>
</tbody>
</table>

#### p-value distribution

##### Full model

![](pipeline2_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

##### Glyph model

###### females

![](pipeline2_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

###### males

![](pipeline2_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

## p value correction with comb-p

### manhattan plots

#### 7 weeks

##### Full model

###### Females, 36 sites

![Full F, 36 sites](./img/pv_fullF.txt.manhattan.png)

###### Males, 80 sites

![Full M, 80 sites](./img/pv_fullM.txt.manhattan.png)

##### Glyph model

###### Females, 29 site

![G F, 29 sites](./img/pv_fullGF7.txt.manhattan.png)

###### Males, 43 site

![G M, 43 sites](./img/pv_fullGM7.txt.manhattan.png)

#### 52 weeks

##### Full model

###### Females, 137 sites

![Full F, 137 sites](./img/pv_fullF12.txt.manhattan.png)

###### Males, 56 sites

![Full M, 56 sites](./img/pv_fullM12.txt.manhattan.png)

##### Glyph model

###### Females, 30 site

![G F,30 sites](./img/pv_fullGF12.txt.manhattan.png)

###### Males, 25 site

![G M, 25 sites](./img/pv_fullGM12.txt.manhattan.png)

## Differentially methylated sites in promoters

Promoters were defined as the regions from 3000 upstream to 300
downstream of the TSS.

<table>
<caption>
Differentially methylated sites in promoters
</caption>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
Full F
</th>
<th style="text-align:right;">
Full M
</th>
<th style="text-align:right;">
Glyph F
</th>
<th style="text-align:right;">
Glyph M
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
7 weeks
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
10
</td>
</tr>
<tr>
<td style="text-align:left;">
12 weeks
</td>
<td style="text-align:right;">
67
</td>
<td style="text-align:right;">
27
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
6
</td>
</tr>
</tbody>
</table>

## Genes

Coordinates of differentially methylated sites were crossed with
Japanese quail’s GFF3 to retrieve differentially methylated sites in
promoters and their genes’ ids.

### Venn diagramms: Genes ID repartition in differentially methylated sites in promoters

#### All models, 7 weeks

![vennplot l7](./img/l7.svg)

#### All models, 52 weeks

![vennplot l52](./img/l12.svg)

#### Full model, all ages

![vennplot lf](./img/lf.svg)

#### Glyph model, all ages

![vennplot lg](./img/lg.svg)

## Enrichment analysis

### Full model

#### 7 weeks

![gp\_full7](./img/full7.png) \#\#\#\# 52 weeks
![gp\_full52](./img/full12.png)

### Glyph model

#### 7 weeks

##### Females

![gp\_glyphf7](./img/GF7.png)

##### Males

![gp\_glyphm7](./img/GM7.png)

#### 52 weeks

##### Females

![gp\_glyphf12](./img/GF12.png)

##### Males 52 weeks

![gp\_glyphm12](./img/GM12.png)

### GOs comparison

see Table

## Some stats

![meanssig](./img/meanssig.png)
