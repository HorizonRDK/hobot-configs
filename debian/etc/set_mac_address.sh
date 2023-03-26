#!/bin/bash
mac_file=/etc/network/mac_address
if ! grep -q '[^[:space:]]' ${mac_file} || [ ! -s ${mac_file}  ]||[ ! -f ${mac_file} ];
then
    openssl rand -rand /dev/urandom:/sys/class/socinfo/soc_uid -hex 6 | sed -e 's/../&:/g;s/:$//' -e 's/^\(.\)[13579bdf]/\10/' > $mac_file
fi
ifconfig eth0 hw ether $(cat ${mac_file})