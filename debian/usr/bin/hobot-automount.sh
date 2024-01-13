#!/bin/bash

pathtoname() {
	udevadm info -p /sys/"$1" | awk -v FS== '/DEVNAME/ {print $2}'
}

devices=$(lsblk -l -o NAME -n -p -d)

for device in $devices; do
	if [[ $device =~ /dev/sd[a-z] ]]; then
		partitions=$(lsblk -l -o NAME -n -p $device)

		for partition in $partitions; do
			if [[ $partition =~ /dev/sd[a-z][0-9]+ ]]; then
				partition_node="/dev/$(basename $partition)"
				echo "Mounting $partition_node..."
				for attempt in {1..5}; do
					udisksctl mount --block-device $partition_node --no-user-interaction && break
					sleep 1
				done
			fi
		done
	fi
done

stdbuf -oL -- udevadm monitor --udev -s block | while read -r -- _ _ event devpath _; do
	if [ "$event" = add ]; then
		devname=$(pathtoname "$devpath")
		if [[ $devname =~ /dev/sd[a-z][0-9]+ ]]; then
			udisksctl mount --block-device "$devname" --no-user-interaction
		fi
	fi
done
