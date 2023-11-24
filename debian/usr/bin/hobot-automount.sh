#!/bin/bash

pathtoname() {
	udevadm info -p /sys/"$1" | awk -v FS== '/DEVNAME/ {print $2}'
}

stdbuf -oL -- udevadm monitor --udev -s block | while read -r -- _ _ event devpath _; do
	if [ "$event" = add ]; then
		devname=$(pathtoname "$devpath")
		if [[ $devname =~ /dev/sd[a-z][0-9]+ ]]; then
			udisksctl mount --block-device "$devname" --no-user-interaction
		fi
	fi
done