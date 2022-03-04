#!/usr/bin/env bash
# This file is assumed to be executed by root
if [ -f /etc/systemd/sleep.conf.bak ]; then
    echo "Restoring /etc/systemd/sleep.conf"
    mv /etc/systemd/sleep.conf.bak /etc/systemd/sleep.conf
fi
