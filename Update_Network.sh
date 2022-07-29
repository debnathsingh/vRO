# Ensure when downloading the location of download is /etc/sysconfig/network-scripts directory.
# Note in case of any issue post runnig this script the backup of the fiel being modified will be available as if-cfg-eth0.org
cd /etc/sysconfig/network-scripts/
mv if-cfg-eth0 if-cfg-eth0.org
vmhostname=$(hostname)
sed 's/INTERFACE_NAME/eth0/g' if-cfg-eth0-master |  sed 's/INTERFACE_DEVICE/eth0/g' | sed 's/DHCPHOSTNAME/$vmhostname/g` > if-cfg-eth0