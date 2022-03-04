#!/usr/bin/env bash

if [ -f /etc/systemd/sleep.conf ]; then
    sudo mv /etc/systemd/sleep.conf /etc/systemd/sleep.conf.bak
fi
sudo printf "[Sleep]\nHibernateMode=reboot" > /etc/systemd/sleep.conf
