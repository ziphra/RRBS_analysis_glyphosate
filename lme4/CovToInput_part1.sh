
module load biokit


mkdir ./totCov
mkdir ./filtered
mkdir ./bed
mkdir ./meth_perc
mkdir ./meth_count
mkdir ./unmeth_count



# add a coverage column
# filtered 10x
# convert to bed file
# create a liste of all cpg position
# create files for methylation %
# create files for methylation count
# create files for unmethylated count

#if anything happened to MS before... 
> ./bed/MS.txt

cd ./rawcov



for file in *cov
do
    # add a total coverage column
    awk -v OFS='\t' 'NF==1{print $0;next}{print $0,($5+$6)}' ${file} > ./totCov/tc_${file}
    # use the 7th column total coverage just added to filtered sites with less than 10x coverage
    grep -v -w "\." ./totCov/tc_${file} | awk -v OFS='\t' '$7>9' - > ./filtered/filt_${file}
    # format the cov file to bed file (useless now)
    awk -v OFS='\t' '{print $1,$2,$3,$4,$5,$6,$7}' ./filtered/filt_${file} > ./bed/${file}.bed
    # store the methyl sites chr($1) and pos($2 $3)
    awk -v OFS='\t' '{print $1,$2,$3}' ./bed/${file}.bed >> ./bed/MS.txt
    # make a file for meth % ($4)
    awk -v OFS='\t' '{print $1,$2,$3,$4}' ./bed/${file}.bed > ./meth_perc/${file}
    # make a file for meth count ($5)
    awk -v OFS='\t' '{print $1,$2,$3,$5}' ./bed/${file}.bed > ./meth_count/${file}
    # make a file for unmethylated sites count ($6)
    awk -v OFS='\t' '{print $1,$2,$3,$6}' ./bed/${file}.bed > ./unmeth_count/${file}
done


#remove duplicated site in the MS list and sort
wc -l ../bed/MS.txt
sort -k1,1 -k2,2n -u ../bed/MS.txt -o ../bed/MS.txt -T ../temp # remove duplicate and sort by chr and by pos
wc -l ../bed/MS.txt

# create a list for methylation %
# create a list for methylation count
# create a list for non methylated count
cp ./bed/MS.txt ./meth_perc/MS_mp.txt
cp ./bed/MS.txt ./meth_count/MS_mc.txt
cp ./bed/MS.txt ./unmeth_count/MS_uc.txt

echo "preprep done"

# run each of these loops in a different batch for time and memory

cd ./bed/


for file in ./*bed
do
    # compare each files with MS so intersecBed will report which sites are not in one samples, and then compare the ouput file to the next sample...
    sort -k1,1 -k2,2n ${file} -T ../temp | intersectBed -a MS.txt -b - -loj -wb -sorted > MS2.txt # sort the chr and pos so intersectBed can call a faster algorithm with -sorted.
    mv MS2.txt  MS.txt # rename MS2 to MS
    echo "${file}" | sed -e 's/^..//' | tr '\n' '\t' >> header_bed.txt #keep track and keep header of which is which

done



cd ./meth_perc/

for file in ./*cov
do
    sort -k1,1 -k2,2n ${file} -T ../temp | intersectBed -a MS_mp.txt -b - -loj -wb -sorted > MS2_mp.txt
    mv MS2_mp.txt  MS_mp.txt
    echo "${file}" | sed -e 's/^..//' | tr '\n' '\t' >> header_bed.txt
done


cd ./meth_count/

for file in *cov
do
    sort -k1,1 -k2,2n ${file} -T ../temp | intersectBed -a MS_mc.txt -b - -loj -wb -sorted > MS2_mc.txt
    mv MS2_mc.txt  MS_mc.txt
    echo "${file}" | sed -e 's/^..//' | tr '\n' '\t' >> header_bed.txt
done



cd ./unmeth_count/

for file in ./*cov
do
    sort -k1,1 -k2,2n ${file} -T ../temp | intersectBed -a MS_uc.txt -b - -loj -wb -sorted > MS2_uc.txt
    mv MS2_uc.txt  MS_uc.txt
    echo "${file}" | sed -e 's/^..//' | tr '\n' '\t' >> header_bed.txt
    done



