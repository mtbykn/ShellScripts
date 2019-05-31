#!/bin/bash

for v in `cat $1`
do
# echo "hostname $1"
 ping $v -c2 && ssh $v "/sbin/ip addr|grep inet"
done

