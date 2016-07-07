#!/bin/bash
for variable in `cat $1`
do
  echo IP address: $variable
  scp $variable:/etc/passwd $variable-users
done
