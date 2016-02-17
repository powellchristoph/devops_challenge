# DevOps Challenge
---------
A coding challenge for DevOps.

#### environment
The environment is build on Rackspace Public Cloud. The application is deployed on three cloud servers behind a cloud loadbalancer. The CICD process is built using Jenkins, Ansible and Github. It will deploy [Ponger](https://github.com/powellchristoph/ponger) on **N** servers.

You can configure the deployment in the [vars.yaml](ansible/vars.yaml) file.
```
# Server prefix
prefix: web
# Server size
flavor: general1-2
# Server image - currently only supports Ubuntu
# note: this image UUID is for Ubuntu 14.04 PVHVM
image: 09de0a66-3156-48b4-90a5-1cf25a905207
# Rackspace Region
region: IAD
# Credentials file
credentials: /root/.rackspace_cloud_credentials
# Number of servers
count: 3
```

The entire infrastructure can be provisioned or tore-down using these Ansible Playbooks: 
- [ansible/setup_site.yaml](ansible/setup_site.yaml)
- [ansible/teardown_site.yaml](ansible/setup_site.yaml)

#### rolling upgrades
Rolling upgrades are executed with the [ansible/rolling_upgrade.yaml](ansible/rolling_upgrade.yaml) playbook.

The rolling_upgrade process:
1. Get load-balancer and node information.
2. Validate the nods and LB are in a healthy status or abort.
3. For each node:
    * Set the node condition to 'draining'.
    * Poll nginx's status page until there are no active connections.
    * Set the node condition to 'disabled'.
    * Upgrade the application using the webservers role.
    * Set the node condition to 'enabled'.

#### bootstrapping
If starting from scratch, you can bootstrap the entire environment using the [bootstrap.sh](bootstrap.sh) script. This will install and configure Ansible for you and provision or teardown the entire environment.
```bash
root@host:~# bash bootstrap.sh
usage: bootstrap.sh -u rax_username -k rax_apikey [deploy | destroy]
```
