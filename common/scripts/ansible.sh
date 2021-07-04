#!/usr/bin/env bash
# install Ansible for provisioning
set -eux

yum -y install python3 python3-pip
pip3 install --upgrade pip
pip3 install ansible
