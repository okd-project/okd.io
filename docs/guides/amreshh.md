# Amresh's Virtual Homelab Setup

<!--- cSpell:ignore Amresh Homelab VM's Ryzen NVME controlplane virt devcontainer virtqemud  dnsmasq --->

This document describes my virtualized OKD homelab of 3 clusters using KVM/QEMU VM's. Infrastructure is provisioned using terraform and the cluster is created using the User-provisioned infrastructure (UPI) method.

Full project details and instructions can be found here: [https://github.com/amreshh/openshift-okd](https://github.com/amreshh/openshift-okd){: target=_blank}
## Host Hardware

Since everything is virtualized, the exact host hardware is not important but make sure you have enough cpu, memory and disk space to run the VM's.

### My specs:
- AMD Ryzen 9 7950X3D (32) @ 5.759GHz
- 64 GB Ram
- 1.5 TB NVME

## OKD Cluster

The OKD cluster consists of 3 controlplane nodes which also act as worker nodes and a bootstrap node to install the cluster. The bootstrap node can be destroyed once the cluster is installed.

|hostname           |cpu's |memory (mib) |ip address    |
|-------------------|------|-------------|--------------|
|okd-bootstrap      |4     |15260        |192.168.150.3 |
|okd-controlplane-1 |4     |15260        |192.168.150.10|
|okd-controlplane-2 |4     |15260        |192.168.150.11|
|okd-controlplane-3 |4     |15260        |192.168.150.12|

|name |domain  |url                                                  |
|-----|--------|-----------------------------------------------------|
|local|okd.lab |https://console-openshift-console.apps.local.okd.lab |

## Host Requirements

- libvirt: used for creating the VM's
- virt-manager: used for managing the VM's
- dnsmasq: used for dns resolution
- Visual Studio Code with the Dev Containers extension: although not strictly necessary, you could install the rest of the tools locally but I choose to develop inside a container to keep my development portable, stable and to keep my host clean.

## Installation

Once the host and pre-requisites have been setup, you can open the project inside the devcontainer. The devcontainer will mount virtqemud-sock from the host inside the container so we can provision the VM's from within the container and setup the rest of the tools.

The VM's are provisioned using terraform and the cluster is created using the User-provisioned infrastructure (UPI) method using the openshift-install cli.
