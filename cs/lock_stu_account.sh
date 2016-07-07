#!/bin/sh

cd /export/home/banner
skip_list="teststu sjobs dmr jcampbe2 jashmore"
ldapou="ou=Students,ou=People,dc=cpsc,dc=umw,dc=edu"
for user in `cat /etc/passwd| awk -F: '{print $1}'`
do
	skip_user=`echo $skip_list | grep "${user}"`
        if [ "$skip_user" != "" ]; then
                echo "$user skipped";
                continue
        fi
	stu_group=`grep "^${user}:" /etc/passwd | grep :1002:`
        if [ "$stu_group" = "" ]; then
                echo "$user not in student group";
                continue
	fi

	already_locked=`grep "^${user}:" /etc/shadow | grep '!!'`
        if [ "$already_locked" != "" ]; then
			mv /cpsc/$user /archive/inactive/$user
			echo "$user already locked" 
		 continue
	fi
	user_valid=`grep "^${user}" /export/home/banner/CPSC_STU.TXT`
        if [ "$user_valid" = "" ]; then
		passwd -l $user
		/usr/lib64/dirsrv/slapd-coriander/ns-inactivate.pl -D "uid=admin,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot" -w `cat /scripts/usr` -h coriander -I "uid=$user,$ldapou"
		echo "dn: uid=$user,$ldapou" > /tmp/imoveuser.ldif
		echo "changetype: moddn" >> /tmp/imoveuser.ldif
		echo "newrdn: uid=$user" >> /tmp/imoveuser.ldif
		echo "deleteoldrdn: 1" >> /tmp/imoveuser.ldif
		echo "newsuperior: ou=inactive,$ldapou" >> /tmp/imoveuser.ldif
		ldapmodify -D "uid=admin,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot" -w `cat /scripts/usr` -h coriander -f /tmp/imoveuser.ldif
#		rm /tmp/imoveuser.ldif
#		mv /cpsc/$user /archive/inactive/$user
                echo "locked ${user} account";
                continue

        fi
done
