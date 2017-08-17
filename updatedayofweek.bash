#!/usr/bin/env bash

# Write 0-6 to the USB serial device. There is a Teensy LC driving
# some LEDs attached to indicate the current day of the week.
date +%w > /dev/ttyACM0
