---
draft: false 
date: 2023-11-14
categories:
  - Guide
---

# Getting up and running with OKD on KVM/QEMU with User Provisioned Infrastructure (UPI)

<!--- cSpell:ignore Amresh Homelab VM's Ryzen NVME controlplane virt devcontainer virtqemud  dnsmasq --->


This guide describes a virtualized OKD homelab of 3 clusters using KVM/QEMU VM's. Infrastructure is provisioned using terraform and the cluster is created using the User-provisioned infrastructure (UPI) method.

<!-- more -->

Full project details and instructions can be found here: [https://github.com/amreshh/openshift-okd](https://github.com/amreshh/openshift-okd){: target=_blank}

## Host Hardware
Since everything is virtualized, the exact host hardware is not important but make sure you have enough cpu, memory and disk space to run the VM's.

### My specs:
- AMD Ryzen 9 7950X3D (32) @ 5.759GHz
- 64 GB Ram
- 1.5 TB NVME

## OKD Cluster

The OKD cluster which will be created, consists of 3 controlplane nodes which also act as worker nodes and a bootstrap node to install the cluster. The bootstrap node can be destroyed once the cluster is installed.

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

The VM's are provisioned using terraform and the cluster is created using the User-provisioned infrastructure (UPI) method using the openshift-install cli.

## Steps
1. Add dnsmasq entries on the host
    ```bash
    address=/okd.lab/192.168.150.3    # bootstrap
    address=/okd.lab/192.168.150.10   # controlplane 1
    address=/okd.lab/192.168.150.11   # controlplane 2
    address=/okd.lab/192.168.150.12   # controlplane 3
    ```
1. Download the QEMU Fedora CoreOS image and extract this into the `coreos/` folder of the project.
1. Download the openshift-install cli and extract this into the `.devcontainer/tools/` folder of the project.
1. Create a `install-config.yaml` file based on the `install-config.yaml.template`
    1. Set the `pullSecret` [https://access.redhat.com/documentation/en-us/openshift_cluster_manager/2023/html/managing_clusters/assembly-managing-clusters#downloading_and_updating_pull_secrets](https://access.redhat.com/documentation/en-us/openshift_cluster_manager/2023/html/managing_clusters/assembly-managing-clusters#downloading_and_updating_pull_secrets).
    1. Fill in the public ssh key of the host machine in the `sshKey` field so you can ssh into the VM's.
1. Open the project inside VSCode's devcontainer, the devcontainer will mount virtqemud-sock from the host inside the container so we can provision the VM's from within the container and setup the rest of the tools. Make sure the mount path to the virtqemud-sock in `.devcontainer/devcontainer` corresponds to the path on the host machine.

Following steps can be done within the terminal of the devcontainer.

1. Generate ignition config files
    ```bash
    openshift-install create ignition-configs --dir ignition_configs/
    ```
1. Provision the VM's
    ```bash
    terraform init
    terraform apply -auto-approve
    ```
1. Install the bootstrap node
    ```bash
    cd ignition_configs
    openshift-install wait-for bootstrap-complete --log-level=debug
    ```
1. The bootstrap node may be destroyed after it is installed.
    ```bash
    cd terraform
    terraform destroy -target=vsphere_virtual_machine.okd-bootstrap -auto-approve
    ```
1. Install the cluster
    ```bash
    cd ignition_configs
    openshift-install wait-for install-complete --log-level=debug
    ```
After installation, the cluster will be accessible at [https://console-openshift-console.apps.local.okd.lab/](https://console-openshift-console.apps.local.okd.lab/). The credentials and kubeconfig file can be found in the `ignition_configs/auth` folder.

## References
- [https://github.com/amreshh/openshift-okd](https://github.com/amreshh/openshift-okd)
