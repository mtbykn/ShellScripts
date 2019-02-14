#!/bin/bash
for variable in `cat $1`
do
  echo IP address: $variable
#    scp $variable:*10??18.* ../patching
scp $variable:*`date +"%m"`??`date +"%y".`* ../patching

done
