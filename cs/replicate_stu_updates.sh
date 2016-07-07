#!/bin/bash

#Name: Replicate Updates: create student accountfrom list / activate prior accounts
#What is does: Updates user Account base with data from Banner: Creates account for student and then creates Posix LDAP components, Activiates and moves accouts to student OU
#DS-LDAP created by smelendy@umw.edu for UMW CPSC

exec<$1

# skip the creation of these users directories - usually used because of bad input from banner
#skip_list="alemast awilson ijones bchang cjones cpetitt eeglest estanton chight jhill15 jedahmen jkwright ckeener lcolelli mifried msteven rwright2 sbdavies tchang whenke cjaynes"
skip_list="teststu,sjobs"
ldapou="ou=Students,ou=People,dc=cpsc,dc=umw,dc=edu"
group=students
while read line
do
        user=`echo $line| awk '{print $1}'`
        skip_user=`echo $skip_list | grep "${user}"`
        if [ "$skip_user" != "" ]; then
                echo "$user skipped";
                continue
        fi
        user_exists=`grep "^${user}:" /etc/passwd`
        if [ "$user_exists" != "" ]; then
		 echo $user exists	
			already_locked=`grep "^${user}:" /etc/shadow | grep '!!'`
          	if [ "$already_locked" != "" ]; then
			echo Reactivating $user 
                	passwd -u -f $user > /dev/null 2>&1
			cat /dev/urandom| tr -dc 'a-zA-Z0-9' | fold -w 20| head -1|passwd $user --stdin
                	echo Activating $user
                	/usr/lib64/dirsrv/slapd-coriander/ns-activate.pl -D "uid=admin,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot" -w `cat /scripts/usr` -h coriander -I "uid=$user,ou=inactive,$ldapou"
			 echo moving $user back to students OU
			 echo "dn: uid=$user,ou=inactive,$ldapou" > /tmp/imoveuser.ldif
			 echo "changetype: moddn" >> /tmp/imoveuser.ldif
  	        	 echo "newrdn: uid=$user" >> /tmp/imoveuser.ldif
        		 echo "deleteoldrdn: 1" >> /tmp/imoveuser.ldif
        		 echo "newsuperior: $ldapou" >> /tmp/imoveuser.ldif
        		 ldapmodify -D "uid=admin,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot" -w `cat /scripts/usr` -h coriander -f /tmp/imoveuser.ldif
               		 rm /tmp/imoveuser.ldif
 	  	 fi
                continue
        fi
	echo Creating $user
        gid=`cat /etc/group | grep $group| cut -d: -f 3`
        comment=`echo $line| awk '{if (NF == "4") print $2 " " $3 ; else if (NF == "5") print $2 " " $3 " " $4}'`
        hostname=`hostname`
	lhomedir=/cpsc/$user
       	homedir=/home/$user
	givenname=`echo $line| awk '{print $2}'`
	sn=`echo $line| awk '{print $3}'`
        password=`echo $line| awk '{print $NF}'`
	echo "=============================== Base User info ======================================="
        echo Username:$user Group:$group $gid $comment On:$hostname $homedir $password $ldapou

	/usr/sbin/useradd -d $homedir -c "$comment" -g $gid -s /bin/false $user 
	cat /dev/urandom| tr -dc 'a-zA-Z0-9' | fold -w 20| head -1|passwd $user --stdin

        mkdir -p /cpsc/$user
        ln -s /shared /cpsc/$user/shared
        mkdir -p /cpsc/$user/public_html
        chown  $user:$group /cpsc/$user
        chown  $user:$group /cpsc/$user/public_html
        chmod 711 /cpsc/$user
        chmod 711 /cpsc/$user/public_html
        /usr/sbin/edquota -p banner $user
	uid=`cat /etc/passwd | grep $user:| cut -d: -f 3`

#DSinfo
echo "===================USERLDAP INFO======================="
echo "dn: uid=$user,$ldapou"
echo "objectclass: inetOrgPerson" 
echo "objectclass: organizationalPerson"
echo "objectClass: top"
echo "objectClass: account" 
echo "objectClass: posixAccount" 
echo "objectClass: shadowAccount" 
echo "cn: $comment"
echo "sn: $sn"
echo "givenName: $givenname"
echo "uid: $user" 
echo "uidNumber: $uid" 
echo "gidNumber: $gid" 
echo "homeDirectory: $homedir" 
echo "LoginShell: /bin/bash" 
echo "gecos: $comment, CPSC Student"
echo "userPassword: $password" 
#echo "shadowLastChange: 0" 
#echo "shadowMax: 0" 
#echo "shadowWarning: 0" 

echo "dn: uid=$user,$ldapou" > /tmp/createpuser.ldif
echo "objectclass: inetOrgPerson"  >> /tmp/createpuser.ldif
echo "objectclass: organizationalPerson"  >> /tmp/createpuser.ldif
echo "objectClass: top" >> /tmp/createpuser.ldif
echo "objectClass: account"  >> /tmp/createpuser.ldif
echo "objectClass: posixAccount" >> /tmp/createpuser.ldif
echo "objectClass: shadowAccount" >> /tmp/createpuser.ldif
echo "cn: $comment" >> /tmp/createpuser.ldif
echo "sn: $sn" >> /tmp/createpuser.ldif
echo "givenName: $givenname" >> /tmp/createpuser.ldif
echo "uid: $user" >> /tmp/createpuser.ldif
echo "uidNumber: $uid" >> /tmp/createpuser.ldif
echo "gidNumber: $gid" >> /tmp/createpuser.ldif
echo "homeDirectory: $homedir" >> /tmp/createpuser.ldif
echo "LoginShell: /bin/bash" >> /tmp/createpuser.ldif
echo "gecos: $comment, CPSC Student" >> /tmp/createpuser.ldif
echo "userPassword: $password" >> /tmp/createpuser.ldif
#echo "shadowLastChange: 0" >> /tmp/createpuser.ldif
#echo "shadowMax: 0" >> /tmp/createpuser.ldif
#echo "shadowWarning: 0" >> /tmp/createpuser.ldif

ldapadd -x -D "uid=admin,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot" -w `cat /scripts/usr` -h coriander -f /tmp/createpuser.ldif
rm /tmp/createpuser.ldif

done

exit 0

