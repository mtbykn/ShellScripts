#!/bin/bash
#DuctTapeDNS - by Shaun Melendy  smelendy@umw.edu
case "$1" in
	-g) 
	echo "generating hosts.duct"
#	~/ducttapedns/gen-duct.sh | sort -k2 > ~/ducttapedns/hosts.duct
	arp-scan --interface=eth0 10.30.89.0/24|grep "98:90:96"|grep -v "DUP"| awk {'print $1 " " $2'}|sort -k2 -n  > arptable
	
	if test -e "hosts.duct"; then 
	rm "hosts.duct" ; fi
	
	for mac in `cat arptable|awk '{print $2}'`
	do
	        IP=`grep $mac arptable|awk {'print $1'}`
	        hostname=`grep $mac hosts.lst |awk {'print $1'}`
		echo $IP $hostname >> hosts.duct
	done
	rm arptable
 	;;

	-c) 
	if test -e "hosts.duct"; then
		echo "moving to /etc/hosts"
		cp /etc/hosts ~
		grep -v TRIN /etc/hosts   > ~/hosts.tmp
		grep "TRIN" ~/ducttapedns/hosts.duct >> ~/hosts.tmp
		cp ~/hosts.tmp /etc/hosts
		rm  ~/ducttapedns/hosts.duct
	else
		echo "no hosts.duct file"
	fi
	;;

 	*)         
	echo "Usage: [-g] generate [-c] copy"
	exit 1
	;;	
esac
#
