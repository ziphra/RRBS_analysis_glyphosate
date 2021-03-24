# p value correction 
With `FDR tool package` and `p.adjust`

see <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6099145/>

## combined-pvalues python package 
see <https://github.com/brentp/combined-pvalues>
### Dependencies
Add missing `'`  in file setup.py, line 20, `long_description=open('README.rst'.read()`     
 
Recquire toolshed: `pip install toolshed`       
Recquire bedtools: installed with homebrew for easy install


#### python 3.7 
Don't work anymore with pyhton 2.7.    
Need to run  comb-p with a python version lower than 3.8: 
`sudo python3.7 setup.py install`


### Make the pvalues lists as sorted bed files
Save the p values as a tab file in R:    
` write.table(pvalues, file = "pvalues.txt", sep = "\t", row.names = TRUE, col.names = FALSE)`


First, fix the chr names, then add a end columns, and sort. 
```
sed 's/"//g' pv_fullF.txt | awk '{sub(/\_/," ",$1)};1' |sed -E -e 's/^.{2}/&_/' | awk '{print $1,$2,$2+1, $3}' OFS="\t" | sort -k1,1 -k2,2n >../bed/ fF.bed 
```

Add header chrom/start/end/p-value mannually 

Run comb-p pipeline: 
`comb-p pipeline -c 4 --seed 0.05 --dist 300 -p S /Users/euphrasieservant/Desktop/combp/bed/S.bed`

## Sites per models and adjustments

| model       | FDR tool      |     p.adjust    |   comb-p   |   no corr | 
| ------------| ------------- | ---------       |---------   |---------  |
| FullF/FullM |        198    |      165        |F:315 M:474 |F:3115 M:2274
| Glyph       |        88     |      79         |254         | 2279
| Sex.        |        115    |      112        |380         | 1714

