#!/usr/bin/env python3
import os
import json
from time import sleep

import os
import time

def gpio_control(pin, value, active="low"):
    """
    Control the GPIO pin level by operating the interfaces under /sys/class/gpio,
    and release the pin after operation completed. 

    :param pin: GPIO pin number
    :param value: GPIO level value, 0 for low, 1 for high
    :param active: Active level of the GPIO, default to low level
    :return: None
    """
    # Define the path of GPIO and the corresponding files
    gpio_path = '/sys/class/gpio/gpio{}'.format(pin)
    value_file = os.path.join(gpio_path, 'value')
    direction_file = os.path.join(gpio_path, 'direction')

    # Export the GPIO pin if it has not been exported
    if not os.path.exists(gpio_path):
        with open('/sys/class/gpio/export', 'w') as f:
            f.write(str(pin))

    # Set the GPIO pin direction to output
    with open(direction_file, 'w') as f:
        f.write('out')

    # Set the active level of GPIO
    if active.lower() == 'high':
        value = str(int(not value))

    # Control the GPIO level
    with open(value_file, 'w') as f:
        f.write(str(value))

    # Wait for 0.01s to ensure successful GPIO control
    time.sleep(0.01)

    # Release the GPIO pin
    with open('/sys/class/gpio/unexport', 'w') as f:
        f.write(str(pin))


if __name__ == '__main__':
    with open("/sys/class/socinfo/som_name", 'r') as f:
        board_id = 'board_' + f.read().strip()

    with open('/etc/board_config.json', 'r') as f:
        data = json.load(f)

    board_config = data[board_id]

    camera_num = board_config['camera_num']
    cameras = board_config['cameras']

    for camera in cameras:
        reset_pin, active_level = camera['reset'].split(':')
        i2c_bus = camera['i2c_bus']
        mipi_host = camera['mipi_host']
        print('Camera reset_pin: {}, active_level: {}, i2c bus: {}, mipi host: {}'.format(reset_pin, active_level, i2c_bus, mipi_host))
        gpio_control(reset_pin, 0, active_level)
        gpio_control(reset_pin, 1, active_level)

