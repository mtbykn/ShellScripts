#!/bin/bash
for variable in `cat $1`
do
  echo $variable
  ssh-copy-id  $variable
#ssh $variable 
done

