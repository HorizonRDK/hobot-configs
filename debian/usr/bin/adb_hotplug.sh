#!/bin/sh
# it is for adb hotplug and udc missed issue...
# just tmp solution by udev rules.

udc_path=/sys/kernel/config/usb_gadget/g1/UDC
udc_name=$(cat $udc_path)

if [ -z $udc_name  ]; then
	echo "b2000000.dwc3" > ${udc_path}
fi
