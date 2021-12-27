#!/bin/sh
export MALTRAIL_LOCAL=$(realpath ~/.local/share/maltrail)
mkdir -p $MALTRAIL_LOCAL
cd $MALTRAIL_LOCAL
wget  https://raw.githubusercontent.com/jardimulisses/maltrail/main/Dockerfile
wget https://raw.githubusercontent.com/stamparm/maltrail/master/maltrail.conf
apt -qq -y install coreutils net-tools docker.io
for dev in $(/usr/sbin/ifconfig | grep mtu | grep -Eo '^\w+'); do /usr/sbin/ifconfig $dev promisc; done
mkdir -p /var/log/maltrail/

