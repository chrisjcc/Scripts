#!/usr/bin/env python
import sys

filename = sys.argv[1]
print filename
file = open(filename, 'r');

count = 1
for FILENAME in  file.read().split('\n'):
    
    print "| [[%ATTACHURLPATH%/"+FILENAME+".pdf][<img width=\"300\" alt=\""+FILENAME+".png\" src=\"%ATTACHURLPATH%/"+FILENAME+".png\" />]] | Figure "+str(count)+": CAPTION ||"
    print ""
    count = count+1

file.close()
