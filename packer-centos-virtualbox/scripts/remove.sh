#!/usr/bin/env bash
# remove Ansible after provisioning
set -eux

pip3 install pip-autoremove
ln -s /usr/bin/pip3 /usr/bin/pip
/usr/local/bin/pip-autoremove ansible -y
rm -f /usr/bin/pip
pip3 uninstall pip-autoremove -y

