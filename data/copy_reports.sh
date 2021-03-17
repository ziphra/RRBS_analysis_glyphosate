#!/bin/sh

#  copy_reports.sh
#  
#
#  Created by Euphrasie Servant on 16/03/2021.
#  
for folder in `cat allfolders.txt`
do

    mkdir /Users/euphrasieservant/Desktop/copy_reports/${folder}
    
    mkdir /Users/euphrasieservant/Desktop/copy_reports/${folder}/trimming_reports
    
    scp servante@puhti.csc.fi:/scratch/project_2003821/RGQMA/RGQMA1/${folder}/trimmed*/*report.txt /Users/euphrasieservant/Desktop/copy_reports/${folder}/trimming_reports
    
    scp servante@puhti.csc.fi:/scratch/project_2003821/RGQMA/RGQMA1/${folder}/trimmed*/*.html /Users/euphrasieservant/Desktop/copy_reports/${folder}/trimming_reports
    
    mkdir /Users/euphrasieservant/Desktop/copy_reports/${folder}/bismarkoutput_reports
    scp servante@puhti.csc.fi:/scratch/project_2003821/RGQMA/RGQMA1/${folder}/bismark_output_${folder}/*report.txt /Users/euphrasieservant/Desktop/copy_reports/${folder}/bismarkoutput_reports
    
    mkdir /Users/euphrasieservant/Desktop/copy_reports/${folder}/meth_reports
    scp servante@puhti.csc.fi:/scratch/project_2003821/RGQMA/RGQMA1/${folder}/meth_${folder}/*splitting_report.txt /Users/euphrasieservant/Desktop/copy_reports/${folder}/meth_reports
    
    mkdir /Users/euphrasieservant/Desktop/copy_reports/${folder}/quality_raw_reports
    scp servante@puhti.csc.fi:/scratch/project_2003821/RGQMA/RGQMA1/${folder}/output_quality_raw_${folder}/*.zip /Users/euphrasieservant/Desktop/copy_reports/${folder}/quality_raw_reports
    
done


