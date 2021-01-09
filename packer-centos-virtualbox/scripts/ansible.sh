#!/usr/bin/env bash
# install Ansible for provisioning
set -eux

yum -y update
yum -y install python3 python3-pip

pip3 install ansible

