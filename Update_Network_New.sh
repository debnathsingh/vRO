# Ensure when downloading the location of download is /etc/sysconfig/network-scripts directory.
# Note in case of any issue post runnig this script the backup of the fiel being modified will be available as if-cfg-eth0.org
networkEth='testeth0'
masterEth='if-cfg-eth0.master'

cd /etc/sysconfig/network-scripts/

if [[ -f $networkEth ]];then
        echo "The network interface '$networkEth' found in $(pwd)"
        echo "Renaming the file '$networkEth' to '$networkEth.org'"
        mv $networkEth $networkEth.org
        vmhostname=$(hostname)
        echo "The hostname is '$vmhostname'"

        if [[ -f $masterEth ]];then
		echo "The master file '$masterEth' is found in $(pwd)"
                echo "Generating the new Ethernet '$networkEth' from '$masterEth'"
                sed 's/INTERFACE_NAME/eth0/g' $masterEth | sed 's/INTERFACE_DEVICE/eth0/g' | sed "s/DHCPHOSTNAME/$vmhostname/g" > $networkEth
                echo "The new Ethernet '$networkEth' is generated"
        else
                echo "The master file '$masterEth' is not found in $(pwd)"
        fi
else
        echo "The network interface '$networkEth' is missing in $(pwd)"
fi
