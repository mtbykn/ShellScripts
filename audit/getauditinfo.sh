#!/bin/bash
for variable in `cat $1`
do
  echo IP address: $variable
#   scp $variable:*-*15.* ../patching 
    scp $variable:*-user-audit-`date +"%m%d%y"`.csv uaudit/
done
