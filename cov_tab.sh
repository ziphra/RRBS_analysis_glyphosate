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

        echo -e -n "\n `basename $filename`" >> allcov3.txt
        
        if [[ "$folder" =~ "G" ]]
        then
            echo -e -n "\t 2" >> allcov3.txt
        
        elif [[ "$folder" =~ "K" ]]
            then
            echo -e -n "\t 1" >> allcov3.txt
        fi
     
        if [[ "$folder" =~ "12" ]]
        then
            echo -e -n "\t 12" >> allcov3.txt
            
        elif [[ "$folder" =~ "7" ]]
        then
            echo -e -n "\t 7" >> allcov3.txt
        fi
        
    done
        
done


    
