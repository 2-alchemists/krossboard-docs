+++
title = "Setup for Cross-Cloud and On-premises Kubernetes (OpenShift, Rancher, etc.)"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

For this kind of deployment, Krossboard is provided either as a ready-to-deploy OVF/VMDK virtual machine appliance, or a setup package for Ubuntu Server 18.04 LTS.

Regardless of the selected deployment approach, the installation steps described hereafter shall be achieved in a couple of minutes. 

## Before you begin
The following key points shall be considered according to the selected deployment approach:

* **For the OVF/VMDK distribution**, a virtual machine manager or a cloud platform supporting this format is required. This format is supported by VirtualBox, VMware Workstation/Player/vSphere, AWS, GCP, and most of modern clouds and virtual machine management systems.
* **For the setup package**, a machine running Ubuntu Server 18.04 LTS (with `sudo` access) is required to perform the installation. The deployment script may have to install missing dependencies (e.g. Docker), hence the machine should have access to official/mirrored Ubuntu repositories.

> **Hardware requirements:** Krossboard itself has a very low resources footprint, the hardware resources allocated to the instance do mainly depend on the number of Kubernetes clusters and namespaces it'll manage. For example, assuming an environment with `10 clusters` we can start with `2 vCPUs` and `512 MB` of memory and then refine them later according to the actual resource utilization observed on the machine.

## Deploy Krossboard using the OVF image
Deploy an instance of Krossboard using the following steps, then jump to the configuration section to set up the integration with your Kubernetes clusters.

* Go to the [release page](https://github.com/2-alchemists/krossboard/releases) and download the latest stable OVF archive.
* Uncompress the downloaded archive and read the NOTICE and the EULA files to learn Krossboard terms of use.
* According to your virtual machine management environement (e.g. VirtualBox, VMware tools, AWS EC2, GCP, etc.), follow its official procedure to import the OVF manifest. The following links are given as indicative references (If a link is broken, please [report it here]({{< relref "/contact/support" >}})).
  * [VirtualBox: Importing Virtual Machines](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/ovf.html#ovf-about).
  * [VMware vSphere: Deploy an OVF or OVA Template](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-17BEDA21-43F6-41F4-8FB2-E01D275FE9B4.html)
  * [VMware Workstation/Player: Import an Open Virtualization Format Virtual Machine](https://docs.vmware.com/en/VMware-Workstation-Player-for-Linux/14.0/com.vmware.player.linux.using.doc/GUID-DDCBE9C0-0EC9-4D09-8042-18436DA62F7A.html).
  * [AWS EC2: Import VM as an Image](https://docs.aws.amazon.com/fr_fr/vm-import/latest/userguide/vmimport-image-import.html#import-vm-image).
  * [GCP: Importing virtual appliances](https://cloud.google.com/compute/docs/import/import-ovf-files).
* Start the virtual machine. 
* Once started, connect to the virtual machine via SSH to continue with the integration with your Kubernetes clusters (see later in this page).
  * Username: `ubuntu`
  * Default password (to be changed): `krossboard` 

## Deploy Krossboard using the setup package
Deploy an instance of Krossboard using the following steps, then move to the configuration section to set up the integration with your Kubernetes clusters.

* Go to the [release page](https://github.com/2-alchemists/krossboard/releases) and download the latest stable setup package.
* Copy the archive to the target installation machine.
* Uncompress it and read the NOTICE and the EULA files to learn Krossboard terms of use.
  ```sh
  cd krossboard-<VERSION>
  sudo ./install
  ```
* Use these commands to launch the installation.

  ```sh
  cd krossboard-<VERSION>
  sudo ./install.sh
  ```
* Once the installation completed, reboot the machine to start the services.

## Configuring the Integration with Kubernetes clusters
* Create (or copy via SSH) the `KUBECONFIG` file of your Kubernetes clusters on the Krossboard machine.
  In the next steps we consider that it's located at `/opt/krossboard/etc/kubeconfig`.

* Make sure that the KUBECONFIG file is owned by the `krossboard` user (a read access for the `krossboard` user is also sufficient).
  
  ```sh
  sudo chown krossboard:krossboard /opt/krossboard/etc/kubeconfig
  ```

* Edit the Krossboard configuration file as follows.
  
  ```sh
  sudo vi /opt/krossboard/etc/krossboard.env

  # Uncomment this line and set the KUBECONFIG variable appropriately.
  KUBECONFIG=/opt/krossboard/etc/kubeconfig
  ```
  
* The configuration shall be taken into account within the next 10 minutes. However, you can force the refresh using this command.

  ```sh
  sudo systemctl restart  krossboard-data-processor-collector
  ```

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL (i.e. http://<machine-addr>/, changing `<machine-addr>` with the address of the instance).
 
**Note:** It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

The default username and password to sign in are:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. 
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* [Discover and explore Krossboard analytics and data export]({{< relref "/docs/analytics-reports-and-data-export" >}})
* [Setup Krossboard for Amazon EKS]({{< relref "/docs/deploy-for-amazon-eks" >}})
* [Setup Krossboard for Azure AKS]({{< relref "/docs/deploy-for-azure-aks" >}})
