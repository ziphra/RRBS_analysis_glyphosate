#!/bin/sh

#  Script.sh
#  
#
#  Created by Euphrasie Servant on 26/01/2021.
#  



for folder in `cat allfolders.txt` # la liste de tous les dossiers ou sont les zero.cov
do


    ls ./$folder/meth_$folder/*.zero.cov > zerocovlist.txt  # je liste tous les zero.cov
    
    for filename in `cat zerocovlist.txt`
    do

        echo -e -n "\n `basename $filename`" >> allcov2.txt
        
        if [[ "$folder" =~ "G" ]]
        then
            echo -e -n "\t 2" >> allcov2.txt
        
        elif [[ "$folder" =~ "K" ]]
            then
            echo -e -n "\t 1" >> allcov2.txt
        fi
     
        if [[ "$folder" =~ "12" ]]
        then
            echo -e -n "\t 12" >> allcov2.txt
            
        elif [[ "$folder" =~ "7" ]]
        then
            echo -e -n "\t 7" >> allcov2.txt
        fi
        
    done
        
done


    
