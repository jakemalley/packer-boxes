#!/usr/bin/env bash
# remove Ansible after provisioning
export BASH_XTRACEFD=1
set -eux

python3 -m pip install pip-autoremove
ln -s /usr/bin/pip3 /usr/bin/pip
/usr/local/bin/pip-autoremove ansible -y
rm -f /usr/bin/pip
python3 -m pip uninstall pip-autoremove -y
