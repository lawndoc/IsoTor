#!/usr/bin/env bash

# remove X1-lock if it exists
[[ -f /tmp/.X1-lock ]] && rm /tmp/.X1-lock && echo "X1-lock found, deleting"

# start Tor browser launcher and restart if closed
while true
do
    gpg --homedir "$HOME/.local/share/torbrowser/gnupg_homedir" --refresh-keys --keyserver keyserver.ubuntu.com
    torbrowser-launcher
    sleep 1
done
