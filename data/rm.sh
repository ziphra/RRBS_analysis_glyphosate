#!/bin/sh

#  rm.sh
#  
#
#  Created by Euphrasie Servant on 16/03/2021.
#  
for folder in `cat allfolders.txt`
do
    rm -rf ./${folder}/bismark_output_${folder}
    rm -rf ./${folder}/data_${folder}
    rm -rf ./${folder}/meth_${folder}
    rm -rf ./trimmed*
done

