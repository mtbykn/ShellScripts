#!/bin/bash
for variable in `cat $2`
do
  echo hostname: $variable
   ssh $variable  "grep $1 /etc/passwd"
done
