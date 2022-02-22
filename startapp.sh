#!/usr/bin/env bash

# remove X1-lock if it exists
[[ -f /tmp/.X1-lock ]] && rm /tmp/.X1-lock && echo "X1-lock found, deleting"
# update to latest Tor browser launcher version
apt-get install --only-upgrade -y torbrowser-launcher

# start Tor browser launcher and restart if closed
while true
do
	/usr/bin/torbrowser-launcher
done
