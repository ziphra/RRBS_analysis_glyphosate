# goatools

see <https://github.com/tanghaibao/goatools> 

## Gene Ontology Enrichment Analyses (GOEA)
### data 
- `go-basic.obo`
- `fF_prom_intersect_GENEIDn.txt`: gene names separated by `\n`   
- `background23k_GENEIDn.txt`: background set gene names separacted by `\n`
- `associations_goatools.txt`: background genes names associated with their GO IDs
	- Through Ensembl BioMart, filters Japanese quail's genome with gene names from the background set (the 23k genes) (that areNCBI gene, formerly Entrezgene accession) to get their GO IDs. 
	- Export the results as a tab file.
	- ```
sort -k2,2 associations.txt | awk '{if($2!=prev) {printf("%s%s\t\t%s",(NR==1?"":"\n"),$2,$1);prev=$2;next;} else printf(" %s",$1);} END{printf("\n");}' FS="\t" | tr " " ";" > associations_goatools.txt 
```

	- manually remove empty fields and `;` in lines with genes with no GO IDs (they all are at the head of the file only) (copy paste them into numbers)

### analysis 
see <https://github.com/tanghaibao/goatools/blob/main/doc/md/README_find_enrichment.md#3-limit-the-goea-to-biological-process-molecular-function-andor-cellular-compartment>

```
python3.7 ../goatools-main/scripts/find_enrichment.py ./data/fF_prom_intersect_GENEIDn.txt ./data/background23k_GENEIDn.txt data/associations_goatools.txt --pval=-1 --method=fdr_bh --pval_field=fdr_bh --outfile=results_id2gos.xlsx
```   
### results 
#### fF
```
HMS:0:00:00.054721  16,020 annotations READ: data/associations_goatools.txt 
Study: 43 vs. Population 2390


Load BP Gene Ontology Analysis ...
Propagating term counts up: is_a
 49%  1,178 of  2,390 population items found in association

Load CC Gene Ontology Analysis ...
Propagating term counts up: is_a
 46%  1,092 of  2,390 population items found in association

Load MF Gene Ontology Analysis ...
Propagating term counts up: is_a
 54%  1,283 of  2,390 population items found in association

Run BP Gene Ontology Analysis: current study set of 43 IDs ... 47%     20 of     43 study items found in association
100%     43 of     43 study items found in population(2390)
Calculating 6,472 uncorrected p-values using fisher
   6,472 GO terms are associated with  1,178 of  2,390 population items
     438 GO terms are associated with     20 of     43 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)

Run CC Gene Ontology Analysis: current study set of 43 IDs ... 37%     16 of     43 study items found in association
100%     43 of     43 study items found in population(2390)
Calculating 764 uncorrected p-values using fisher
     764 GO terms are associated with  1,092 of  2,390 population items
      81 GO terms are associated with     16 of     43 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)

Run MF Gene Ontology Analysis: current study set of 43 IDs ... 49%     21 of     43 study items found in association
100%     43 of     43 study items found in population(2390)
Calculating 1,467 uncorrected p-values using fisher
   1,467 GO terms are associated with  1,283 of  2,390 population items
     104 GO terms are associated with     21 of     43 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)
   8703 items WROTE: results_id2gos.xlsx
(base) Euphrasies-MacBook-Pro:goatools_enrichment euphrasieservant$ python3.7 ../goatools-main/scripts/find_enrichment.py ./data/fF_prom_intersect_GENEIDn.txt ./data/background23k_GENEIDn.txt data/associations_goatools.txt --pval=-1 --method=fdr_bh --pval_field=fdr_bh --outfile=results_id2gos.xlsx --no_propagate_counts
go-basic.obo: fmt(1.2) rel(2021-02-01) 47,291 GO Terms
HMS:0:00:00.054426  16,020 annotations READ: data/associations_goatools.txt 
Study: 43 vs. Population 2390


Load BP Gene Ontology Analysis ...
 49%  1,178 of  2,390 population items found in association

Load CC Gene Ontology Analysis ...
 46%  1,092 of  2,390 population items found in association

Load MF Gene Ontology Analysis ...
 54%  1,283 of  2,390 population items found in association

Run BP Gene Ontology Analysis: current study set of 43 IDs ... 47%     20 of     43 study items found in association
100%     43 of     43 study items found in population(2390)
Calculating 3,548 uncorrected p-values using fisher
   3,548 GO terms are associated with  1,178 of  2,390 population items
      70 GO terms are associated with     20 of     43 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)

Run CC Gene Ontology Analysis: current study set of 43 IDs ... 37%     16 of     43 study items found in association
100%     43 of     43 study items found in population(2390)
Calculating 560 uncorrected p-values using fisher
     560 GO terms are associated with  1,092 of  2,390 population items
      35 GO terms are associated with     16 of     43 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)

Run MF Gene Ontology Analysis: current study set of 43 IDs ... 49%     21 of     43 study items found in association
100%     43 of     43 study items found in population(2390)
Calculating 1,038 uncorrected p-values using fisher
   1,038 GO terms are associated with  1,283 of  2,390 population items
      36 GO terms are associated with     21 of     43 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)
   5146 items WROTE: results_id2gos.xlsx
```


#### fM

```
go-basic.obo: fmt(1.2) rel(2021-02-01) 47,291 GO Terms
HMS:0:00:00.051409  16,020 annotations READ: data/associations_goatools.txt 
Study: 58 vs. Population 2390


Load BP Gene Ontology Analysis ...
 49%  1,178 of  2,390 population items found in association

Load CC Gene Ontology Analysis ...
 46%  1,092 of  2,390 population items found in association

Load MF Gene Ontology Analysis ...
 54%  1,283 of  2,390 population items found in association

Run BP Gene Ontology Analysis: current study set of 58 IDs ... 40%     23 of     58 study items found in association
100%     58 of     58 study items found in population(2390)
Calculating 3,548 uncorrected p-values using fisher
   3,548 GO terms are associated with  1,178 of  2,390 population items
     163 GO terms are associated with     23 of     58 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)

Run CC Gene Ontology Analysis: current study set of 58 IDs ... 40%     23 of     58 study items found in association
100%     58 of     58 study items found in population(2390)
Calculating 560 uncorrected p-values using fisher
     560 GO terms are associated with  1,092 of  2,390 population items
      33 GO terms are associated with     23 of     58 study items
  METHOD fdr_bh:
       0 GO terms found significant (< 0.05=alpha) (  0 enriched +   0 purified): statsmodels fdr_bh
       0 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)

Run MF Gene Ontology Analysis: current study set of 58 IDs ... 45%     26 of     58 study items found in association
100%     58 of     58 study items found in population(2390)
Calculating 1,038 uncorrected p-values using fisher
   1,038 GO terms are associated with  1,283 of  2,390 population items
      64 GO terms are associated with     26 of     58 study items
  METHOD fdr_bh:
       2 GO terms found significant (< 0.05=alpha) (  2 enriched +   0 purified): statsmodels fdr_bh
       4 study items associated with significant GO IDs (enriched)
       0 study items associated with significant GO IDs (purified)
   5146 items WROTE: results_id2gos.xlsx
(base) Euphrasies-MacBook-Pro:goatools_enrichment euphrasieservant$ wc -l ./data/associations_goatools.txt 
    1721 ./data/associations_goatools.txt
(base) Euphrasies-MacBook-Pro:goatools_enrichment euphrasieservant$ wc -l ./data/background23k_GENEIDn.txt 
    2390 ./data/background23k_GENEIDn.txt
```

## word search 
### Key words 
`mithocond/oxygen/heme/oxydo/tetrapyrrole`    
We want to retrieve every GO terms that has any of these terms in either its name or its definition. 

- `gawk -v ORS="\n\n" 'BEGIN {IGNORECASE = 1; RS="\n\n"} /heme/||/mitochond/||/oxygen/||/oxydo/||/tetrapyrrole/||/cytochrome/ {print}' go-basic.obo > ../keywords_search/ROS_obo.txt`

- `grep "id: " ../keywords_search/ROS_obo.txt | sed 's/^....//' > ../keywords_search/GOID_ros.txt`

After it's done for the whole `.obo`, we can do it on the study's background (the 23k sites), and count the GO terms for comparison.  
  
- Get GO id's from`cat ./data/associations_goatools.txt | awk -v FS="\t\t" '{print $2}' | tr ";" "\n" > GOIDS_23k.txt`
- `sh Script.sh` to count ROS related GO

#### ROS related 
`mithocond/oxygen/heme/oxydo/tetrapyrrole`

#### Reproduction 
`/testosterone/ || /steroid/ || /folliculogenesis / || /estrogen / || /reproductive hormone/ || /oocyte/ || /sperm/ || /male/ || /female/ || /reproduction/`

#### acetylcholine esterase
see <https://doi.org/10.1016/j.etap.2016.05.012>
`/acetylcholine/ || /acetyltransferase/ || /cholinesterase/ || /cholinergic/ || /muscar/ || /nicotin/`

#### testosterone 
see <https://doi.org/10.1016/j.tiv.2011.12.009>



## Group GO terms... 
See [article](https://doi.org/10.1038/s41598-018-28948-z)

- Run `wr_sections.py file`:

```
  WROTE: go-basic.obo

  356 GO IDs READ: sorted_fFM_goids.txt
requests.get(http://www.geneontology.org/ontology/subsets/goslim_generic.obo, stream=True)
  WROTE: goslim_generic.obo

goslim_generic.obo: fmt(1.2) rel(None) 247 GO Terms
go-basic.obo: fmt(1.2) rel(2021-02-01) 47,291 GO Terms; optional_attrs(relationship)
goslim_generic.obo: fmt(1.2) rel(None) 247 GO Terms
hdr GOs(     0 in  0 sections,  84 unused) WROTE: sections_in.txt
hdr GOs(     0 in  0 sections,  84 unused) WROTE: sections.txt
  WROTE: grouped_gos.txt
   356 user GO IDs
   
```

|    | GO ID      |   | hdr |        | descendant count |   | level | depth |     | aliases for depth-01 GO terms. |      |      | GO name           |
|----|------------|---|-----|--------|------------------|---|-------|-------|-----|--------------------------------|------|------|-------------------|
| ** | GO:0006783 | # | BP  | 1 uGOs | 11               | 5 | L04   | D07   | R07 | AC                             | .... | prdu | heme biosynthetic |


- Retrieve GO terms that match `GOID_ros_related.txt`: `grep -f ../keywords_search/GOID_ros_related.txt ./grouped_gos.txt`
- copy paste the results from above in a new section in file `sections_in.txt` and run `wr_sections.py file` again 
- Now that ROS related GO terms are grouped, let's plot the terms: 
`go_plot.py -i ROS_related.txt -o inter.png --sections=sections.txt`
![](./img/inter_ROS_F.png)
- Remove (or add) terms that are out (or not) of interest in the group. 

Same for other keywords.  

