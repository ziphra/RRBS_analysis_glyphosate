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
`echo -e -n "chr\tpos1\tpos2" | paste - header >> header403`

merge the header to the MS:   
just cat. 
`for file in no0_MS*; do cat header403 $file > whead_${file}; done`



**To remove the chr and pos duplicated columns:**  

- Make a list of columns to keep: every 4th columns from the 7th column, until the last column (403th):    
`seq 7 4 403 > coltokeep2` 
- Add the chr and the pos colum (the first one only):  
`echo -e -n "1\n2" > coltokeep1` 
- and cat the lists:   
`cat coltokeep1 coltokeep2 > coltokeep` 
- Replace the `\n` with `",$"` so the list can be used to select columns with awk:   
`cat coltokeep | tr "\n" ",$"` 
- Add the first missing $ by hand... 
- Run: 

```
for file in whead*
do 
	awk -v OFS='\t' '{print $1,$2,$7,$11,$15,$19,$23,$27,$31,$35,$39,$43,$47,$51,$55,$59,$63,$67,$71,$75,$79,$83,$87,$91,$95,$99,$103,$107,$111,$115,$119,$123,$127,$131,$135,$139,$143,$147,$151,$155,$159,$163,$167,$171,$175,$179,$183,$187,$191,$195,$199,$203,$207,$211,$215,$219,$223,$227,$231,$235,$239,$243,$247,$251,$255,$259,$263,$267,$271,$275,$279,$283,$287,$291,$295,$299,$303,$307,$311,$315,$319,$323,$327,$331,$335,$339,$343,$347,$351,$355,$359,$363,$367,$371,$375,$379,$383,$387,$391,$395,$399,$403}' $file > ctk_${file}
done
```

- concatenate the chr and pos column: 

```
for file in ctk*;
do 
	sed 's/\t/_/' $file > chr_pos_${file}
done
```

### Create a data table sampleID\_name\_file_sex\_fam
To add the parent ID to the table, since we only have the ParentID number for the ID7: 

- Copy the 7 weeks ID column with corresponding 12 months ID from the Ruuskanen\_glypho\_quail\_methyl\_samplelist\_7wk_12mo\_20200319 file and parent ID  from Glypho_quail_parentID (by sorting the columns so individuals come in the same order). Thus, we have a 3 columns file ID7/ID12/ParentID. 
- Retrieve ID from the cov file names in the table, with TEXTBETWEEN functions. 
- Divide the table in 2, one for 7 weeks, one for 12 months. 
- Sort the ID columns the same way 
- Copy and paste the ParentID column

### Create a siblings matrix  
