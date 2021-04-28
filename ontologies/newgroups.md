# Manually group GO terms, without using goatools. 

Same thing than with goatools, except that we don't look for match in the groupeds GO terms define by goatools, but directly in the terms names and definitions of all the GOs terms present in the genes of interest. 

- Find GO IDs that have names or definition matching with any of the keywords: `gawk -v ORS="\n\n" 'BEGIN {IGNORECASE = 1; RS="\n\n"} /key/||/words/ {print}' go-basic.obo > key_obo.txt`
- `sed -i '' 's/^/id: /' mygoids.txt`
- `cat mygoids.txt | tr "\n" "Z" | sed -e "s/Z/\/ || \//g" > mygoids_gawk.txt`
- Find mygoids.txt present in `key_obo.txt `: `gawk -v ORS="\n\n" 'BEGIN {IGNORECASE = 1; RS="\n\n"} /MY/ || /GOIDS/ {print}' key_obo.txt > file.txt`
- Copy results in number. 

grouping.sh 

## Putative effects of Glyphosate and keywords
Ruuskanen, S., Rainio, M.J., Gómez-Gallego, C., Selenius, O., Salminen, S., Collado, M.C., Saikkonen, K., Saloniemi, I., Helander, M., 2020. **Glyphosate-based herbicides influence antioxidants, reproductive hormones and gut microbiome but not reproduction: A long-term experiment in an avian model.** Environmental Pollution 266, 115108. <https://doi.org/10.1016/j.envpol.2020.115108>

### ROS 

**keywords:** `/mitochond/ || /antioxydant/ || /heme/ || /superoxid/ || /tetrapyrrole/ || /catalase/ || /peroxidase/ || /glutathione/ || /peroxidation/ || /oxygenase/ || /oxid/ || /cytochrome/` 


### testosterone 
- Clair É. et al, 2012. **A glyphosate-based herbicide induces necrosis and apoptosis in mature rat testicular cells in vitro, and testosterone decrease at lower levels.** Toxicology in Vitro 26, 269–279. <https://doi.org/10.1016/j.tiv.2011.12.009>
	- measured the differential specificities of R and G actions on adult rat freshly separated testicular cells in order to know the threshold of toxicity. 
	- decrease in testosterone and an aromatase mRNA increase
	- disrupt steroidogenic acute regulatory (StAR) protein expression

- Romano et al. 2010. **Prepubertal exposure to commercial formulation of the herbicide glyphosate alters testosterone levels and testicular morphology.** Arch Toxicol 84, 309–317. <https://doi.org/10.1007/s00204-009-0494-z>
	- no differences in serum corticosterone or estradiol levels but in testosterone yes
	- delay in pubertal age
	- increased in the testicular and adrenal weights with concentration of G feed.

- Manservisi et al. 2019. **The Ramazzini Institute 13-week pilot study glyphosate-based herbicides administered at human-equivalent dose to Sprague Dawley rats: effects on development and endocrine system.** Environ Health 18, 15. <https://doi.org/10.1186/s12940-019-0453-y>
	- + testosterone in female
	- delay in maturation 
	- increase in thyroid stimulating hormone
	- increase in sex hormone binding globulin
	- decrease DHT/testosterone ration in both sexes. 

- Darbandi, et al, 2018. **Reactive oxygen species and male reproductive hormones.** Reprod Biol Endocrinol 16, 87. https://doi.org/10.1186/s12958-018-0406-2



**keywords**: `/testi/ || /testosterone/ || /dihydrotestosterone/ || /steroidogenic/ || /steroid/ || /estradiol/ || /corticosterone/ || /aromatase/ || /androgen/ || /estrogen/ || /gonadotropin/`

### acetylcholine esterase
- Larsen et al. 2019. **Environmental Toxicology and Pharmacology 45**, 41–44. <https://doi.org/10.1016/j.etap.2016.05.012>

- Bali et al. 2019. **Learning and memory impairments associated to acetylcholinesterase inhibition and oxidative stress following glyphosate based-herbicide exposure in mice.** Toxicology 415, 18–25. <https://doi.org/10.1016/j.tox.2019.01.010>
	- over-stimulation of both muscarinic and nicotinic cholinergic receptors
	- oxidative stress could be another key mechanism that underlies neurotoxic effects of this herbicide


**keywords:** `/acetylcholine/ || /acetylcholine esterase/ || /muscarinic/ || /nicotinic/ || /cholinergic/ || /`



