#!/bin/bash
source config.sh

installation() {

#INSTALLATION 

echo " Welcome to the Installtion of Zee"


DIR5=$location/response.varfile
mkdir $location/tempfolder

cp response.varfile $location/tempfolder
chmod 777 $location/tempfolder/response.varfile

valueres="location"
valueres1="localhost"
echo "location on $DIR5"
echo $LINE | sed -i "s:$valueres:$location:g" $DIR5
echo $LINE | sed -i "s:$valueres1:$mysql_host:g" $DIR5 
echo "fileDir value changed"

# Checking Server status

cd $location

mysql -u $mysql_user -p -u mysql_host -e "set global max_connections = 500;"



	echo "Installing Zephyr $build"

  

echo "Zephyr Dir created"
 	sudo sh zephyr_4.8_${build}\_setup_iRev_$changeset.sh -q -c -varfile response.varfile
	echo " build number $build Installed"
	echo "Checking Zephyr Service"
	sleep 15 
if [ "( $RUNNING | grep "ZephyrService" )" ]; then
	
     echo "ZephyrServer is running"
	/etc/init.d/ZephyrService.sh stop
	echo "ZephyrServer is Stopped"
else
		
    	echo "Zephyr is not running"
fi




# changes in hazelcast-hibernet
echo " Welcome to Hazelcast-hibernet changes"

New1="$nodeip1:5702" 
New2="$nodeip2:5702"

DIR3=/opt/zephyr/tomcat/webapps/flex/WEB-INF/classes/hazelcast-hibernate.xml
echo "Adding hazelcast-hibernate ips"


sed -i "s|\(<member>\)[^<>]*\(</member>\)|\1${New1}\2|" $DIR3

echo "hazelcast-hibernate ip $New1 added"

echo "Member one Added  on hazelcast-hibernet"
CONTENT="<member>$New2</member>"
sed -i.bak '/<\/member>/ i \'$CONTENT $DIR3
echo "Member two added on hazelcast-hibernet"

sed -i "s|\(<interface>\)[^<>]*\(</interface>\)|\1$subnet\2|" $DIR3

echo " Interface added on hazelcast-hibernet"


#changing the hazelcast.xml.tmpl

New3="$nodeip1:5701"
New4="$nodeip2:5701"

DIR1=/opt/zephyr/tomcat/webapps/flex/WEB-INF/template/hazelcast.xml.tmpl

sed -i "s|\(<member>\)[^<>]*\(</member>\)|\1${New3}\2|" $DIR1

echo " Member one added on hazelcast.xml.tmpl"

CONTENT1="<member>$New4</member>"
sed -i.bak '/<\/member>/ i \'$CONTENT1 $DIR1
echo "Member two added on hazelcast.xml.tmpl"

sed -i "s|\(<interface>\)[^<>]*\(</interface>\)|\1$subnet\2|" $DIR1
echo " Interface addedon hazelcast.xml.tmpl"


# Changes in Jdbc.properties
ElasticIp1=$esip1:9300
ElasticIp2=$esip2:9300
#replaceValue=$ip
DIR2=/opt/zephyr/tomcat/webapps/flex/WEB-INF/classes/jdbc.properties
#echo $LINE | sed -i "s/$dbOldIp/$replaceValue/g" $DIR2
value="elastic.client=node"
replace="elastic.client=transport"
echo $LINE | sed -i "s/$value/$replace/g" $DIR2
value1="#transport.nodes=localhost:9300"
replace1="transport.nodes=$ElasticIp1,$ElasticIp2"
DIR=jdbc.properties
echo $LINE | sed -i "s/$value1/$replace1/g" $DIR2


#CLUSTER.PROPERTIES CHANGES
echo "Welcome to cluster.properties changes"
echo "copying the cluster.properties file from templ"
cd  /opt/zephyr/tomcat/webapps/flex/WEB-INF/template
echo " you are in templete"
cp cluster.properties.tmpl $location
echo " filed copied to setup $location"
cd $location
mv cluster.properties.tmpl cluster.properties
echo " name changed from cluster.properties.tmpl to cluster.properties "
chmod 777  cluster.properties
replaceValue1="cluster.node.1.url=$nodeip1"
searchvalue1="cluster.node.1.url=127.0.0.1"
replaceValue2="cluster.node.2.url=$nodeip2"
searchvalue2="cluster.node.2.url=127.0.0.2"
DIR4=$location/cluster.properties
echo $LINE | sed -i "s/$searchvalue1/$replaceValue1/g" $DIR4
echo $LINE | sed -i "s/$searchvalue2/$replaceValue2/g" $DIR4
echo "ip for node1 changed as $nodeip1"
echo "ip for node2 changed as $nodeip2"
sudo cp $location/cluster.properties /opt/zephyr/tomcat/webapps/flex/WEB-INF/classes
	echo "cluster.properties copied"

}


installation 