#!/bin/sh
# Reports Quota Info to Cinnamon and Cayenne
/usr/sbin/repquota /cpsc|grep -v -- "--" |sort -k3 -n |grep 0 > /scripts/tmp/quotareport
# repquota /cpsc|grep -v -- "--" |sort -k3 -n |grep 0 |awk {'print $1'}| xargs mailx -s "Your personal CPSC file space in the Linux lab is near capacity limits"  

for user in `cat /scripts/tmp/quotareport| awk '{print $1}'`
	do
		used=`grep $user /scripts/tmp/quotareport | awk {'print $3'}` 
		softlimit=`grep $user /scripts/tmp/quotareport | awk {'print $4'}`
		hardlimit=`grep $user /scripts/tmp/quotareport | awk {'print $5'}`
		gdays=`grep $user /scripts/tmp/quotareport |grep -v "none"| awk {'print $65'}`
		email=$user@mail.umw.edu
		echo "Your space on the CPSC Linux Lab has exceed your quota of $softlimit kb and will cause issues once you hit $hardlimit kb. Please Login to cs.umw.edu with your account $user and free up space to fix this issue. Thanks CPSC support."| mailx -s "CPSC Linux Lab file space near limits $gdays" $email
	done

