#!/bin/bash
#getversions.sh script by smelendy for umw.
#purpose: grab version info for servers
#distrodetect portion from http://www.novell.com/coolsolutions/feature/11251.html

OS=`uname -s`
REV=`uname -r`
MACH=`uname -m`

GetVersionFromFile()
{
	VERSION=`cat $1 | tr "\n" ' ' | sed s/.*VERSION.*=\ // `
}
if [ "${OS}" = "SunOS" ] ; then
	OS=Solaris
	ARCH=`uname -p`	
	OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
	pkginfo -l |egrep "PKGINST|NAME|VERSION"
elif [ "${OS}" = "Linux" ] ; then
	KERNEL=`uname -r`
	if [ -f /etc/redhat-release ] ; then
		DIST='RedHat'
		PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
		REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
		yum list | awk '{print $1, ", version " $2}'
	elif [ -f /etc/debian_version ] ; then
		DIST="Debian `cat /etc/debian_version`"
		REV=""
		 dpkg --list | awk '{print $2, ", version " $3}'
	fi
	OSSTR="${OS} ${DIST} ${REV}(${PSUEDONAME} ${KERNEL} ${MACH})"
fi
echo ${OSSTR}

echo Version report of `hostname` on ${OSSTR} system has successfully completed on `date`

#echo apache2
#/usr/sbin/apache2 -v
#echo Nagios NRPE
#/export/home/nagios/nagios/libexec/check_nrpe -H localhost
#echo java
#java -version

