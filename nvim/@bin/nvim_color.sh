#!/usr/bin/env bash

nvr --serverlist | \
while read line; do
    nvr --nostart -cc ":set background=$1" --servername $line & \
done
