# Data preparation for Lme4 

See [script](./CovToInput_part1.sh)

See [Bedtools intersectBed tool](https://bedtools.readthedocs.io/en/latest/content/tools/intersect.html)

After filtering sites with less than 10x coverage, **2362801 methyl sites** were left. 

To filter sites that are not in all samples: `for file in MS*, do grep -v -w "\." $file > no0_${file}; done`
  
After filtering sites that were not present in all of the individuals, **440977 methyl sites were left**


### add header
```
for file in ../rawcov/*
do 
	for i in `seq 4`; do echo -e -n "`basename $file`\t" >> header; done; 
done
``` 

To check the number of column:  
`head -n 1 ./header | awk '{print NF}'`

Add `chr pos1 pos2` as the 3 first columns header:  
`echo -e -n "chr\t pos1\t pos2\t" | paste - header >> header 403`

merge the header to the MS:   
```
for file in no0_MS_*; do echo -e "`cat headear403`\n `cat $file`" > whead_${file};done
```
