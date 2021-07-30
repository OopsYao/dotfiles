#!/usr/bin/env bash

nvr --serverlist | \
while read line; do
    nvr --nostart -cc ':source $MYVIMRC' --servername $line & \
done
