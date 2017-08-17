#!/usr/bin/env bash

# Blink some lights if the temperature exceeds TMAX.
#
# The lights are driven by a USB-serial device /dev/ttyACM0. The 'a'
# command displays the alarm pattern.

TEENSY_LC=/dev/ttyACM0
if [ ! -c ${TEENSY_LC} ]; then
    echo "Unable to find ${TEENSY_LC}."
    exit 1
fi

TMAX=45

re='temp1_input: *([0-9]*)'
sensors -u | while IFS= read -r line
do
    if [[ "$line" =~ $re ]] ; then
        k=${BASH_REMATCH[1]}
        if (( $TMAX < $k )); then
            printf "a" > /dev/ttyACM0
        fi
        break
    fi
done
