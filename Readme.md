## 📖 Overview

This repository houses the infrastructure definitions for my homelab. Its primary purpose is to provide a platform to practice on various technologies. 

The homelab compute resources are built on a Proxmox hypervisor which hosts non-containerized virtual machines,
alongside a dedicated 3-node Talos bare metal Kubernetes cluster. Networking is primarily Unifi network applicances. Non-Compute storage and backups are housed on a Synology NAS. 

---

## Infrastructure Management

### Proxmox

Proxmox is used as the virtualization platform for non-containerized workloads. Virtual machines and
resources in Proxmox are managed through:

- **Terraform**: Manages Proxmox virtual machine resources and configurations
- **Ansible**: Handles configuration management tasks for Proxmox hosts and VMs

This area is still evolving and I've working on migrations here. The IAC is not quite up to date. Mostly reference at this point. 

### Kubernetes

The primary Kubernetes cluster ("orion") runs on a 3-node bare metal [Talos Linux](https://www.talos.dev/) 
installation. Talos provides a minimal, immutable Linux distribution designed specifically for Kubernetes.

#### Core Components

- **Gateway API**: Manages ingress traffic using [Gateway API](https://gateway-api.sigs.k8s.io/)
- **External Secrets**: Integrates with 1Password for secret management
- **Cert Manager**: Handles certificate automation with Let's Encrypt
- **ArgoCD**: Provides GitOps-based application deployment

### Directories

This Git repository contains the following directories under [Kubernetes](./kubernetes/):

```sh
📁 kubernetes
├── 📁 orion              # Talos-based "orion" cluster
│   ├── 📁 apps           # Applications deployed via ArgoCD
│   ├── 📁 manifests      # Core infrastructure components
│   └── 📁 bootstrap      # Cluster bootstrap procedures
└── 📁 terraform          # Terraform configurations for Proxmox
```

## Dependencies

| Service    | Use  |
|--------|---------|
| [1Password](https://1password.com/) | Secret Store        |
| [Cloudflare](https://www.cloudflare.com/)| Domain  |
| [GitHub](https://github.com/)| Hosting this repository    |
| [LetsEncrypt](https://letsencrypt.com/)| Certificates |

---

##  Hardware

| Device  | Count | OS Disk Size | Data Disk Size    | Ram  | Operating System | Purpose      |
|-------|-------|---------|--------------|------|---------|--------------|
| UniFi UDMP                          | 1     | -            | -                            | -    | -                | Router & NVR            |
| UniFi US-24-250W                    | 1     | -            | -                            | -    | -                | 1Gb PoE Switch          |
| APC                                 | 1     | -            | -                            | -    | -                | UPS                     |
| Super Mirco X8DTL-iF, 2x Xeon E5620 | 1     | -            | -                            | 96GB| Proxmox v8.x.x   | Compute                 | 
| Lenovo ThinkCentre M715q Tiny Ryzen 5 Pro 2400GE 3.20 GHz | 3    | -            | -       | 8 GB | Talos Linux   | Compute                 |

---

