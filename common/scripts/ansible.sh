#!/usr/bin/env bash
# install Ansible for provisioning
export BASH_XTRACEFD=1
set -eux

yum -y install python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install ansible
