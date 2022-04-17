#!/bin/bash
# ichhosts.sh 
# By smelendy
# Purpose creates formated Icinga hosts

exec<$1
while read line
do
hostip=`echo $line | awk {'print $1'}`
hostname=`echo $line | awk {'print $2'}`
hostos=`echo $line | awk {'print $3'}`
hosttemplate="camera-host"
hosttype="camera"


case $hostos in
Microsoft) hosttemplate="windows-host" ;;
Red) hosttemplate="linux-host" ;;
CentOS) hosttemplate="linux-host" ;;
Ubuntu) hosttemplate="linux-host" ;;
esac


echo "$hostname" 

echo "object Host \"$hostname\" { " >> $1.conf
echo "import  \"$hosttemplate\" " >> $1.conf 
echo "address = \"$hostip\" " >> $1.conf 
echo "vars.type = \"$hosttype\" " >> $1.conf
echo "}" >>  $1.conf
echo ""  >> $1.conf

done
exit 0
