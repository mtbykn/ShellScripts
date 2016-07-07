#!/bin/bash
#finds user name on servers user listfiles
#Created by Shaun Melendy smelendy@umw.edu

 if [ -z "$1" ]; then 
	echo " finduser.sh  <username> <list>"
	exit 1
 fi
 if [ -z "$2" ]; then
        echo " finduser.sh  <username> <list>"
	exit 1
 fi

for variable in `cat $2`
do
  echo hostname: $variable
   ssh $variable "cat /etc/passwd| grep $1" 
done
