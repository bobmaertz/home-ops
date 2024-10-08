## 📖 Overview

This repository houses the infrasturcture definitions for my homelab. Its a
work in progress and may contain bugs / incompatibilities. 

The homelab is built on a proxmox hypervisor which needs to be installed before 
moving onto installation. 

---


## Ansible 
The Ansible playbooks in this mono-repo are a WIP feature to bring up a bare metal K8s cluster from scratch. The running installation 
does not work well with the existing virtualized components in the lab however the installation itself is otherwise operational. 

More information about the Ansible setup and current state can be found in its [Readme](./ansible/Readme.md) 


## Kubernetes

The k3s-dev cluster is running on a vanilla k3s installation on three nodes (1 control, 2 worker) using 
[k3s-ansible](https://github.com/k3s-io/k3s-ansible) for provisioning. As part of that installation, the cluster
is using Traefik (ingress) and ServiceLB by default. 


### Core Components

TODO: 

### Directories

This Git repository contains the following directories under [Kubernetes](./kubernetes/).

```sh
📁 kubernetes
├── 📁 k3s-dev            # k3s-dev cluster
│   ├── 📁 apps           # applications
│   ├── 📁 bootstrap      # bootstrap procedures
│   └── 📁 templates      # re-useable components
└── 📁 ...             # other clusters
```

## Dependencies

| Service                                         | Use                                                               |
|-------------------------------------------------|-------------------------------------------------------------------|
| [1Password](https://1password.com/)             | XXXXXXXX                                                          |
| [Cloudflare](https://www.cloudflare.com/)       | Domain and S3                                                     |
| [GitHub](https://github.com/)                   | Hosting this repository                                           |
|                                                 |                                                                   |

---

##  Hardware

| Device                              | Count | OS Disk Size | Data Disk Size               | Ram  | Operating System | Purpose                 |
|-------------------------------------|-------|--------------|------------------------------|------|------------------|-------------------------|
| UniFi UDMP                          | 1     | -            | -                            | -    | -                | Router & NVR            |
| UniFi US-24-250W                    | 1     | -            | -                            | -    | -                | 1Gb PoE Switch          |
| APC                                 | 1     | -            | -                            | -    | -                | UPS                     |
| Super Mirco X8DTL-iF, 2x Xeon E5620 | 1     | -            | -                            | 96GB| Proxmox v8.x.x   | Compute                 | 

---

