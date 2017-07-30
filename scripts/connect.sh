#!/bin/bash
wpa_supplicant -B -iwlp1s0 -c./wpa.conf -Dwext
dhclient wlp1s0
iwconfig
ifconfig
