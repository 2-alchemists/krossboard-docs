+++
title = "Setup for Cross-Cloud and On-premises Kubernetes"
description = ""
weight = 60
draft = false
bref = ""
toc = true
aliases = ["/docs/deploy-for-cross-cloud-and-on-premises-kubernetes/"]
+++

This page describes how to set up Krossboard for Kubernetes instances running on-premises and/or across different clouds. Especially, it addresses the deployment for Red Hat OpenShift, Rancher RKE, as well as other vanilla Kubernetes distributions. 

For this kind of deployment, Krossboard you can use either our ready-to-deploy OVF/VMDK virtual appliance images, or our setup packages available for Ubuntu Server 18.04 LTS.

Regardless of the selected deployment approach, the installation steps described hereafter shall be achieved in a couple of minutes.

## Before you begin
The following key points shall be considered according to the selected deployment approach:

* **For the OVF/VMDK distribution**, a virtual machine manager or a cloud platform supporting this format is required. This format is supported by VirtualBox, VMware Workstation/Player/vSphere, AWS, GCP, and most of modern clouds and virtual machine management systems.
* **For the setup package**, a machine running Ubuntu Server 18.04 LTS (with `sudo` access) is required to perform the installation. The deployment script may have to install missing dependencies (e.g. Docker), hence the machine should have access to official/mirrored Ubuntu repositories.
* [Kubernetes Metrics Server](https://github.com/kubernetes-sigs/metrics-server) is required by Krossboard to retrieve some basic metrics from Kubernetes.
  If it's not yet the case, you need to install it on each cluster.
  
  ```bash
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  ```

* **Hardware requirements:** Krossboard itself has a very low resources footprint, the hardware resources allocated to the instance do mainly depend on the number of Kubernetes clusters and namespaces it'll manage. For example, assuming an environment with `10 clusters` we can start with `2 vCPUs` and `512 MB` of memory and then refine them later according to the actual resource utilization observed on the machine.

## Deploying Krossboard
This section covers the installation either via the OVF virtual machine appliance or via the binary package. The both procedures are described hereafter, once the instance deployed jump to the configuration section to finish the integration with your Kubernetes clusters.

### Deployment using the OVF image
The below steps assume you're running a cloud environment, or a virtual machine manager supporting the importation of OVF images.

* Go to the [Release Page](https://github.com/2-alchemists/krossboard/releases) and download the latest stable OVF archive.
* Uncompress the downloaded archive and review the NOTICE and the EULA files to learn Krossboard terms of use.
* According to your virtual machine management environment, refer to the following official procedures to import the OVF manifest.
  * [VirtualBox: Importing Virtual Machines](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/ovf.html#ovf-about).
  * [VMware vSphere: Deploy an OVF or OVA Template](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-17BEDA21-43F6-41F4-8FB2-E01D275FE9B4.html)
  * [VMware Workstation/Player: Import an Open Virtualization Format Virtual Machine](https://docs.vmware.com/en/VMware-Workstation-Player-for-Linux/14.0/com.vmware.player.linux.using.doc/GUID-DDCBE9C0-0EC9-4D09-8042-18436DA62F7A.html).
  * [AWS EC2: Import VM as an Image](https://docs.aws.amazon.com/fr_fr/vm-import/latest/userguide/vmimport-image-import.html#import-vm-image).
  * [GCP: Importing virtual appliances](https://cloud.google.com/compute/docs/import/import-ovf-files). 
    
  > The above links are given as indicative references; if you find a broken link, please report the problem [here]({{< relref "/contact/support" >}}).
* Start the virtual machine.
* Once the virtual machine started, connect to it via SSH and move to the configuration section.
  * Username: `ubuntu`
  * Default password: `krossboard` (to be changed as soon as possible for production setup)

### Deploy using the binary package
The below steps assume you're running an Ubuntu Server 18.04 LTS operating system.

* Go to the [release page](https://github.com/2-alchemists/krossboard/releases) and download the latest stable setup package.
* Copy the archive to the target installation machine.
* Uncompress the archive and review the NOTICE and the EULA files to learn Krossboard terms of use.
  ```sh
  tar zxf krossboard-<VERSION>.tgz
  cd krossboard-<VERSION>
  ```
* Use this command to launch the installation.

  ```sh
  sudo ./install.sh
  ```
* Once the installation completed, reboot the machine to start the services.

## Integration with Kubernetes clusters
The integration of your Kubernetes clusters with Krossboard implies the following two straight steps.

* Using SSH (or another mean), copy your different Kubernetes `KUBECONFIG` files into the folder `/opt/krossboard/data/kubeconfig.d` of the Krossboard machine. Any valid `KUBECONFIG` file stored in this folder will be automatically discovered and handled by Krossboard (required Krossboard version `1.2.0` or later).
* Make sure that the Krossboard system services do still have full access to that folder.

  ```sh
  sudo chown -R krossboard:krossboard /opt/krossboard/data/kubeconfig.d
  ```

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL (i.e. `http://<machine-addr>/`, changing `<machine-addr>` with the address of the instance).

> It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

Here are the default username and password to sign in:

* **Username:** `krossboard`
* **Password (default):** `Kr0sSB8qrdAdm`

> It's highly recommended to change this default password as soon as possible.
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Troubleshooting
In case of problem, first checkout the [Troubleshooting Page]({{< relref "/docs/901_troubleshooting" >}}) for an initial investigation.

If the problem you're experiencing is not listed there, open a ticket on the [Krossboard GitHub Page](https://github.com/2-alchemists/krossboard/issues).

Alternatively, if you do have an active support contract, you can also send an email directly to our customer support service: `support at krossboard.app`.

## Other Resources
* [Discover and explore Krossboard analytics and data export]({{< relref "02_analytics-and-data-export" >}})
* [Setup Krossboard for Google GKE]({{< relref "20_deploy-for-google-gke" >}})
* [Setup Krossboard for Azure AKS]({{< relref "30_deploy-for-azure-aks" >}})
* [Setup Krossboard for Amazon EKS]({{< relref "50_deploy-for-amazon-eks" >}})