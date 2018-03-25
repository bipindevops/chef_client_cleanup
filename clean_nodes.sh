#!/bin/sh

for node in $(knife search node "ec2:* AND ohai_time:[* TO $(date +%s -d '3 days ago')]" -i); do
  nslookup $node > /dev/null 2>&1
  status=$( echo $? )
  if [[ $status == 1 ]] ; then
    ip_address=$(knife node show $node -a ipaddress|grep ipaddress|awk '{print $2}')
    response=`ping -W1 -c1 $ip_address | grep received | awk '{print $4}'`
    if [[ $response == 0 ]] ; then
     #Connection failure
     echo "Inactive EC2 Instances: "$node
     #knife node delete $node
     #knife client delete $node
    fi
  fi
done
