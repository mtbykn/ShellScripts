
#!/bin/bash
#User Account Audit Script smelendy@umw
 #Get Base Data
 grep -v "nologin" /etc/passwd|awk -F ":" '{print $1 "," $4 "," $5}' > tmp 
 #primary group 
 for x in `cat tmp |awk -F "," '{print $2}'`
  do
  y=`grep $x /etc/group |awk -F ":" '{print $1}'`
  sed -i "s/$x/$y/" tmp
  done
 #seconday group
 echo "  " > `hostname`-user-audit-`date +"%m%d%y"`.csv
 for v in `cat tmp| awk -F "," '{print $1}'`
  do
  echo -n "`grep $v tmp`," >> `hostname`-user-audit-`date +"%m%d%y"`.csv
    for g in `cat /etc/group|grep $v |awk -F ":" '{print $1 ","}'`
     do
     echo -n " $g " >> `hostname`-user-audit-`date +"%m%d%y"`.csv
     done
  echo "  " >> `hostname`-user-audit-`date +"%m%d%y"`.csv
  done
echo "Script Complete"

