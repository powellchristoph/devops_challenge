#!/bin/bash

# TODO
# - write out given credentials to /root/.rackspace_cloud_credentials

# create ssh keypair
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
ssh-agent bash
ssh-add ~/.ssh/id_rsa

# install ansible
apt-get -y install software-properties-common python-dev python-pip curl
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible

# NOTE: FOR DYNAMIC INVENTORY FROM CLOUD ACCOUNT. MIGHT NOT NEED IT.
# configure rs_module
pip install pyrax
# missing pyrax deps; https://github.com/rackspace/pyrax/issues/570
pip install wrapt
pip install monotonic
pip install netifaces
curl https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/rax.py -o /etc/ansible/rax.py
chmod +x /etc/ansible/rax.py

# get repo
# copy over /etc/ansible/ansible.cfg
# copy over /etc/ansible/hosts
