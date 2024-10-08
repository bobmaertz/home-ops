# Ansible Homelab Resources

This is a collector of roles and playbooks for configuration of homelab resources.
The playbooks and roles are currently written to interact with an Ubuntu distribution. 

## Roles
The following roles are used in the playbooks with brief descriptions. 

### general
This role contains general tasks applicable to all nodes. Examples include updating packages, 
installing common packages, and firewall additions. 

### k8common
This role contains tasks common to all k8 nodes.  

#### Dependencies 
- geerlingguy.containerd

### k8control 
This role contains tasks specific to a control node. It does not yet support HA configurations. 

### k8worker
This role contains tasks specific to a worker node. 

### postgres 
This role is a WIP for posgres bare metal installation. 

