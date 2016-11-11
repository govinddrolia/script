#!/bin/bash

###declare
echo "HOSTMACHINE/REMOTE/BOTH"
read server
echo "Where you want to execute script? Type LOCAL or IP's(max 3 including local)"
read  host host1 host2 host3
echo "Enter the values for  location; followed by ENTER: "
read location 
echo "Enter the values for  mysql_user; mysql_host; followed by ENTER: "
read mysql_user mysql_host
echo "Enter the build Number : "
read build
echo "Enter the changeset Number: "
read changeset
echo "Enter the values for nodeip1; nodeip2; subnet;   followed by ENTER: "
read nodeip1 nodeip2 subnet 
echo " Enter the ES ip 1 with the port"
read esip1
echo " Enter the ES ip 2"
read esip2
echo "Need to stop sever Are you sure ? YES/NO"
read stop


echo "#!/usr/bin/env bash" > ./config.sh 
echo host=$host >> ./config.sh
echo host1=$host1 >> ./config.sh
echo host2=$host2 >> ./config.sh
echo host3=$host3 >> ./config.sh
echo location=$location  >> ./config.sh
echo mysql_user=$mysql_user >> ./config.sh
echo mysql_host=$mysql_host >> ./config.sh
echo build=$build >> ./config.sh
echo changeset=$changeset >> ./config.sh
echo subnet=$subnet >> ./config.sh
echo esip1=$esip1 >> ./config.sh
echo esip2=$esip2 >> ./config.sh
echo nodeip1=$nodeip1 >> ./config.sh
echo nodeip2=$nodeip2 >> ./config.sh



remote() {

rsync -avzhpo ./config.sh second.sh cluster@$host1:/home/zephyr
rsync -avzhpo ./config.sh second.sh cluster@$host2:/home/zephyr
rsync -avzhpo ./config.sh second.sh cluster@$host3:/home/zephyr

ssh cluster@$host1 sudo sh /home/zephyr/second.sh
ssh cluster@$host1 sudo sh /home/zephyr/second.sh
ssh cluster@$host1 sudo sh /home/zephyr/second.sh
}

localhost () {
	/bin/bash ./second.sh
}


if [ "$server" == "LOCAL" ]; then

       localhost

elif [[ "$server" == "REMOTE" ]]; then

		remote
	else 
		localhost
		remote
fi





