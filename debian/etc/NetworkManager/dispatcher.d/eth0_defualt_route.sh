#!/bin/bash

if [ "$2" = "up" ]; then
	case "$1" in
		eth0)
			ip route del default via 192.168.1.1 dev eth0
			ip route add default via 192.168.1.1 dev eth0 metric 700

			ip route del 192.168.1.0/24 via 0.0.0.0 dev eth0
			ip route add 192.168.1.0/24 via 0.0.0.0 dev eth0 metric 700
			;;
		*)
			;;
	esac
fi
