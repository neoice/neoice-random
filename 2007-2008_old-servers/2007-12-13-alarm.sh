#! /bin/bash

echo -n "Time (sec): "
read time

sleep $time

cat /dev/urandom > /dev/console




## BEEPS ARE LAME!
#
#while true;
#do
#   echo -e "\a" #SYSTEM BEEP
#   sleep .1
#done

