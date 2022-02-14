#!/bin/sh

#  Script.sh
#  
#
#  Created by Euphrasie Servant on 11/02/2022.
#




# compare with goatool
compare_gos.py ./Full/7/f7.txt ./Full/7/m7.txt ./Full/12/f12.txt ./Full/12/m12.txt ./Glyph/7/GF7.txt ./Glyph/7/GM7.txt ./Glyph/12/GF12.txt ./Glyph/12/GF12.txt > ./allmodels/compare_allmodels.txt


# Squeeze multiple occurrences of spaces to one space
grep "^X\|^\." ./allmodels/compare_allmodels.txt > ./allmodels/compare_all_greped.txt

# replace multiple spaces with one
tr -s " " < ./allmodels/compare_all_greped.txt | sed 's/^/;/' | awk '{first = $1; $1 = ""; print $0, first; }' | sed 's/^ //g' > ./allmodels/compare_all_tred.txt

# replace spaces with ; to make it csv friendly
sed -i '' 's/,/./' ./allmodels/compare_all_tred.txt #transform , to .
sed -i '' 's/ /;/' ./allmodels/compare_all_tred.txt
sed -i '' 's/ /;/' ./allmodels/compare_all_tred.txt
sed -i '' 's/ /;/' ./allmodels/compare_all_tred.txt
sed -i '' 's/ /;/' ./allmodels/compare_all_tred.txt




cat ./Full/7/f7.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done



cat ./Full/7/m7.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done




cat ./Full/12/f12.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done



cat ./Full/12/m12.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done


cat ./Glyph/7/GF7.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done

cat ./Glyph/7/GM7.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done


cat ./Glyph/12/GF12.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done


cat ./Glyph/12/GM12.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/;$b/" "./allmodels/compare_all_tred.txt"
done



# Marker keys:
#     X....... -> GO is present in f7
#     .X...... -> GO is present in m7
#     ..X..... -> GO is present in f12
#     ..X..... -> GO is present in m12
#     ...X.... -> GO is present in GF7
#     ....X... -> GO is present in GM7
#     .....X.. -> GO is present in GF12
#     ......X. -> GO is present in GF12
