#!/bin/sh

#  Script.sh
#  
#
#  Created by Euphrasie Servant on 12/04/2021.
#  
gawk -v ORS="\n\n" 'BEGIN {RS="\n\n", IGNORECASE = 1} /heme/||/mitochond/||/oxygen/||/oxydo/||/tetrapyrrole/||/cytochrome/ {print}' go-basic.obo > ../keywords_search/ROS_related_obo.txt

grep -i "id: " ../keywords_search/ROS_related_obo.txt | sed 's/^....//' > ../keywords_search/GOID_ros_related.txt

sh Script.sh

wr_sections.py file

grep -f ../keywords_search/GOID_ros_related.txt ./grouped_gos.txt | cat



go_plot.py -i ROS_related.txt -o inter.png --sections=sections.txt

wr_sections.py file
