#!/usr/bin/env bash

nvr --serverlist | \
while read line; do
    nvr --nostart -cc ":lua colo('$1')" --servername $line & \
done
