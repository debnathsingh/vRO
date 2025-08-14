####################################################################################################################
##Name						:	install_crowdstrike.sh
##Description				:	Script to install Crowdstrike agent on Linux Server Version 6, 7, 8
##Version					:	1.0
##Created by				:	Automation Team
##Created on				:	Jan 27, 2022
##Modified by				:	Automation Team
##Modified on				:	Jan 27, 2022
##Note						:	assumes script and rpm are copied from Azure CSE extension
####################################################################################################################

#!/bin/bash
cd /home/dsolclsa_svc
release=$(cat /etc/redhat-release)
echo $release
if [[ $release == *"release 6"* ]];then
	echo "Proceeding with script of release 6"
	sudo yum -y install RHEL_sensor-OR6.rpm
	sudo /opt/CrowdStrike/falconctl -s --cid=86CB413E353B455A9FCEDDC4AD1A19DE-55
	service falcon-sensor start
	chkconfig falcon-sensor on
	echo "Checking the falcon process"
	ps -ef | grep -i falcon
elif [[ $release == *"release 7"* ]];then
	echo "Proceeding with script of release 7"
	sudo yum -y install RHEL_sensor-OR7.rpm
	sudo /opt/CrowdStrike/falconctl -s --cid=86CB413E353B455A9FCEDDC4AD1A19DE-55
	systemctl enable falcon-sensor
	systemctl start falcon-sensor
	echo "Checking the falcon process"
	ps -ef | grep -i falcon
elif [[ $release == *"release 8"* ]];then
	echo "Proceeding with script of release 8"
	sudo yum -y install RHEL_Sensor-OR8.rpm
	sudo /opt/CrowdStrike/falconctl -s --cid=86CB413E353B455A9FCEDDC4AD1A19DE-55
	systemctl enable falcon-sensor
	systemctl start falcon-sensor
	echo "Checking the falcon process"
	ps -ef | grep -i falcon
else
	echo "Release is neither of RHEL version 6, 7, 8"
fi
