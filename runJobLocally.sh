#!/usr/bin/env sh

cat $1
| xargs -n 1 sh -c 'head -n 10 batch_output/load_Analysis.o$0'
| grep -v "=== Finishing"
| grep -v "\--- Beginning"
| sed -e 's/Using file pattern:\s*\(\w*\)/\1/g'
-e 's/Run part of sample with ID:\s*\(\w*\)/\1/g'
-e 's/Decay channel:\s*\(\w*\)/\1/g'
-e 's/Systematic variation:\s*\(\w*\)/\1/g'
-e 's/Running on jet categories with ID:\s*\(\w*\)/\1/g'
-e 's/Running the following analysis modes:\s*\(\w*\)/\1/g'
| sed 's/,//g'
| sed 's/.root//g'
| xargs -n 6 sh -c 'echo "nohup ./install/bin/load_Analysis -f $0.root -p $1 -c $2 -s $3 -j $4 -m $5 >& log/$5_$0_$1_$2_$3_$4_$5.log &"'



