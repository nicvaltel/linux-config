#!/bin/bash

BAT=$(upower -i `upower -e | grep 'BAT'` | grep -E 'state:|percentage:' | sed 's/.*: //g; s/ //g; s/fully-charged/+/; s/discharging/-/; s/charging/+/' | sed -z 's/\n//')

first_char="${BAT:0:1}"
plus="+"

if [[ $first_char == $plus ]]
then
  echo "<fc=#33cc33>$BAT</fc>"
else
  echo "<fc=#ff3300>$BAT</fc>"
fi
