+++
title = "Setup for Cross-Cloud and On-premises Kubernetes (OpenShift, Rancher, etc.)"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

For this kind of deployment, Krossboard is provided either as a binary package for Ubuntu Server 18.04 LTS, or a ready-to-use OVF/VMDK virtual machine appliance.

Regardless of the selected deployment approach, the installation steps described hereafter shall be achieved in a couple of minutes. 

## Before you begin
According to the selected deployment approach, the following key points shall be considered:

* **For the OVF/VMDK distribution**, a virtual machine manager or a cloud environment supporting this format is required. Most of modern virtual machine management tools do support this format (e.g. VirtualBox, VMware tools, OpenStack, etc.).
* **For the binary package**, a machine running Ubuntu Server 18.04 LTS is required. A `sudo` access is required to perform the installation. The deployment script may have to install missing dependencies (e.g. Docker), hence the machine should have access to official/mirrored Ubuntu repositories.

> **Hardware requirements:** Krossboard itself has a very low resources footprint, the hardware resources allocated to your instance do mainly depend on the among of Kubernetes clusters and namespaces in each one. For example, assuming that you `10 clusters` you can start with the following specifications and update it later according to the resource utilization (`vCPU: 2`, `RAM: 1024 MB`).

## Deploy Krossboard using the OVF image

* Go to the [release page](https://github.com/2-alchemists/krossboard/releases) and download a OVF package of Krossboard.
* The package is a zip archive. Uncompress it and read the NOTICE and the EULA files to learn its terms use.
* According to your virtual machine management tool (e.g. VirtualBox, VMware tools, OpenStack, etc.), follow the official procedure to import OVF application. The following links are given as indicative references (If a link is broken, please [report it here]({{< relref "/contact/support" >}})).
  *  [VirtualBox: Importing Virtual Machines](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/ovf.html#ovf-about).
  * [VMware vSphere: Deploy an OVF or OVA Template](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.vm_admin.doc/GUID-17BEDA21-43F6-41F4-8FB2-E01D275FE9B4.html)
  * [VMware Workstation/Player: Import an Open Virtualization Format Virtual Machine](https://docs.vmware.com/en/VMware-Workstation-Player-for-Linux/14.0/com.vmware.player.linux.using.doc/GUID-DDCBE9C0-0EC9-4D09-8042-18436DA62F7A.html).
* Start the imported virtual machine. 
* Once started, connect to the virtual machine via SSH to continue with the integration with Kubernetes clusters below (see below).
  * Username: `ubuntu`
  * Default password (to be changed): `krossboard`

## Deploy Krossboard using the binary distribution
* Go to the [release page](https://github.com/2-alchemists/krossboard/releases) and download a binary package of Krossboard.
* The package is a zip archive, copy the archive to the target installation machine.
* Uncompress it and read the NOTICE and the EULA files to learn its terms use.
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

## Integration with Kubernetes clusters
* Create or copy via SSH the `KUBECONFIG` file of your Kubernetes clusters on the Krossboard machine.
  In the next steps we consider that it's located at `/opt/krossboard/etc/kubeconfig`.

* Make sure that the KUBECONFIG file is readable by the `krossboard` user.
  
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
Open a browser tab and point it to the Krossboard URL displayed at the end of the installation script. **Note:** It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

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
* [Setup Krossboard for AAzure AKS]({{< relref "/docs/deploy-for-azure-aks" >}})