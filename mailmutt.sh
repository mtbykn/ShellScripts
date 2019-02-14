#!/bin/bash

# Emails Three files to specified Tickets.

    if [ -z "$1" ]; then  
       echo " mailmutt.sh by smelendy@umw.edu  ERROR: Type in ticket Number" ;  exit 1
     else
    if [ -z "$2" ]; then
  export EMAIL=smelendy@umw.local && echo "`hostname` Patching" | mutt  -e "my_hdr From:smelendy@umw.edu" -s "[OS Patching #$1]" -a "`hostname`-prepatch-`date +"%m%d%y"`.csv" -a "`hostname`-postpatch-`date +"%m%d%y"`.csv" -a "`hostname`-`date +"%m%d%y"`.txt" -- patching-reply@rt.umw.local

  echo mutt -s "[OS Patching #$1]" -a "`hostname`-prepatch-`date +"%m%d%y"`.csv" -a "`hostname`-postpatch-`date +"%m%d%y"`.csv" -a "`hostname`-`date +"%m%d%y"`.txt" -- patching-reply@rt.umw.local

   else 
   export EMAIL=smelendy@umw.local && echo "`hostname` Patching" | mutt  -e "my_hdr From:smelendy@umw.edu" -s "[OS Patching #$1]" -a "`hostname`-prepatch-$2.csv" -a "`hostname`-postpatch-$2.csv" -a "`hostname`-$2.txt" -- patching-reply@rt.umw.local 

  echo mutt -s "[OS Patching #$1]" -a "`hostname`-prepatch-$2.csv" -a "`hostname`-postpatch-$2.csv" -a "`hostname`-$2.txt" -- patching-reply@rt.umw.local
 fi
fi 

