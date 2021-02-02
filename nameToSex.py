import os
import json
import csv

sexidstr = 'sexid.json'
nameidstr = 'sampleID_name_and_file2.json'
sexIdMap = {}
res = {} # dict that will store our result

def main():
	#Open first file
	with open(sexidstr) as currentFile:
		json_object = json.load(currentFile)

		#Create HashMap object that maps sex->id
		for i in range(0, len(json_object)):
			sex = json_object[i]["Sex"]
			sexid = json_object[i]["id"]
			sexIdMap[sexid] = sex
	
	#Open second
	with open(nameidstr) as currentFile:
		json_object = json.load(currentFile)

		#Traverse the name section
		#For each name we want to see if it contains the key of 
		#Our previous sexIdMap. If it does we map it to the id we want
		for i in range(0, len(json_object)):
			name = json_object[i]["name"]
			keys = sexIdMap.keys() # we will have the keys
			for key in keys:
				if key in name:
					# We found id that corresponds to the name
					res[name] = sexIdMap[key]

	#Build the result
	with open('result.csv', 'w') as f:
	    for key in res.keys():
	        f.write("%s,%s\n"%(key,res[key]))
if __name__ == '__main__':
    main()