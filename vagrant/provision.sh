#!/bin/bash
set -x
set -e

apt-get -y update

dpkg -s python &>/dev/null || {
    apt-get -y install python
}

sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
systemctl restart sshd
