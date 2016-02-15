#!/bin/bash

usage() {
    echo "usage: bootstrap.sh -u rax_username -k rax_apikey [deploy | destroy]"
}

setup() {
    ## create ssh keypair/ setup agent
    if [[ ! -f ~/.ssh/id_rsa ]]; then
        ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    fi
#    ssh-agent bash
    ssh-add ~/.ssh/id_rsa

    # install some deps
    apt-get -y install software-properties-common python-dev python-pip curl git
    
    # install ansible
    apt-add-repository -y ppa:ansible/ansible
    apt-get update
    apt-get -y install ansible
    rm -rf /etc/ansible/*
    
    # configure rs_module
    pip install pyrax
    # missing pyrax deps; https://github.com/rackspace/pyrax/issues/570
    pip install wrapt
    pip install monotonic
    pip install netifaces
    #curl https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/rax.py -o /etc/ansible/rax.py
    #chmod +x /etc/ansible/rax.py
    
    # get repo
    if [[ -d /tmp/devops_challenge ]]; then
        rm -rf /tmp/devops_challenge
    fi
    git clone https://github.com/powellchristoph/devops_challenge.git /tmp/devops_challenge
    cp -a /tmp/devops_challenge/ansible/* /etc/ansible/.
}

deploy() {
#    if ! which ansible >/dev/null; then
#        echo "Cannot find ansible, did setup() run correctly?"
#        exit 1
#    fi

    # bootstrap environment
    ansible-playbook -i /etc/ansible/rax.py /etc/ansible/setup_site.yaml
    if [[ $? -ne 0 ]]; then
        echo "Something went wrong creating the environment."
        exit 1
    else
        echo "Your environment is ready."
    fi
}

destroy() {
    ansible-playbook -i /etc/ansible/rax.py /etc/ansible/teardown_site.yaml
    if [[ $? -ne 0 ]]; then
        echo "Something went wrong destroying the environment."
        exit 1
    else
        echo "Your environment is gone."
    fi
}

function=0
while [[ $# > 0 ]]; do
    case $1 in
        -u)
            rax_username=$2
            shift
            ;;
        -k)
            rax_apikey=$2
            shift
            ;;
        deploy)
            function=1
            ;;
        destroy)
            function=2
            ;;
        -h | --help)
            usage
            exit
            ;;
        *)
            usage
            exit 1
    esac
    shift
done

if [ -z $rax_username ] || [ -z $rax_apikey ]; then
    usage
    echo "No credentials given, quitting."
    exit 1
fi

cat <<EOF > ~/.rackspace_cloud_credentials
[rackspace_cloud]
username = $rax_username
api_key = $rax_apikey
EOF

case $function in
    0)
        usage
        echo "No function given, quitting"
        exit 1
        ;;
    1)
        setup
        deploy
        ;;
    2)
        destroy
        ;;
esac
