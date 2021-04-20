+++
title = "Setup for Azure AKS Clusters"
description = ""
weight = 30
draft = false
bref = ""
toc = true
aliases = ["/docs/deploy-for-azure-aks/"]
+++

On Microsoft Azure, Krossboard is available as ready-to-use virtual machine images. This release approach makes its deployment as simple than creating a virtual machine.

Once deployed, the Krossboard instance is able to automatically discover and handle your AKS clusters. By default, the discovery works on a per [Azure resource group](https://docs.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal) basis, meaning that the instance does automatically discover and handle all your AKS clusters belonging to the resource group in which it's deployed.

This guide shows how to setup Krossboard for a given Azure resource group. It'll take you a couple of minutes to make it up and running.

## Before you begin
This installation guide assumes that:

* You have at least a basic level of practice with Azure concepts.
* You have an active Azure subscription with administrator permissions to create and configure your Krossboard instance.   **Krossboard itself needs _read-only access_ to your AKS clusters**.
* You have access to a `bash >=4` terminal (or [Azure Cloud Shell](https://azure.microsoft.com/features/cloud-shell/)) where you can use Azure CLI. 
* You have [`kubectl`](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal.

### Sign in to Azure
Open a terminal and perform the following commands to sign in to Azure and export variables required during the installation.

```sh
az login
export AZURE_TENANT_ID=$(az account show --query "tenantId" | cut -d'"' -f2)
export AZURE_SUBSCRIPTION_ID=$(az account show --query id | cut -d'"' -f2)
echo "AZURE_TENANT_ID => $AZURE_TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID => $AZURE_SUBSCRIPTION_ID"
```

### Consent to use Krossboard Image Gallery
Azure requires that you consent to use a Image gallery from a third party.

Open a web browser and point it to the following URL. Change `$AZURE_TENANT_ID` with your tenant ID (see the above steps). 

> https://login.microsoftonline.com/**$AZURE_TENANT_ID**/oauth2/authorize?client_id=72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0&response_type=code&redirect_uri=https%3A%2F%2Fwww.microsoft.com%2F

Verify that the application is `krossboard-gallery-app`, then check `Consent on behalf of your organization` and click **Accept**. 

## Deploy a Krossboard instance
The commands below shall deploy an instance of Krossboard in a couple of minutes.

Before running the commands, review and set the following variables suitably:
  * The variable `AZURE_GROUP` sets the name of the resource group in which your AKS clusters are located.
  * The variable `KB_AZURE_VM_NAME` sets the name of the instance (default is automatically generated).
  * The variable `KB_AZURE_LOCATION` sets the deployment location (default is `centralus` -- see the [list of regions with available images]({{< relref "/docs/03_releases_information" >}})).
  * The variable `KB_AZURE_VM_SIZE` sets the VM size (default is `Standard_B1ms` -- what should be sufficient unless you have a big number of AKS clusters along with many namespaces in the target resource group). 
  * The installation uses the option `--generate-ssh-keys` of Azure CLI, meaning that it uses the local SSH key pair for the instance. The associated SSH username is `azureuser`.

```sh
# deployment parameters
export AZURE_GROUP="YOUR_AZURE_GROUP_WITH_AKS"
export KB_AZURE_VM_NAME="krossboard-`date +%F-%s`"
export KB_AZURE_VM_SIZE='Standard_B1ms'
export KB_AZURE_LOCATION='centralus'
curl -so krossboard_azure_install.sh \
    https://raw.githubusercontent.com/2-alchemists/krossboard/master/tooling/setup/krossboard_azure_install.sh && \
    bash ./krossboard_azure_install.sh
```

On success a summary of the installation shall be displayed as below:
```
=== Summary the Krossboard instance ===
Instance Name => krossboard-2020-08-18-1595880565
Resource Group => prod
Krossboard UI => http://1.2.3.4/
```

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL displayed at the end of the installation script. 

The IP address of the instance is displayed at the end of the installation script. You can also get it on the Azure portal.

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

## Handling New AKS clusters
During the installation, the Krossboard deployment script discovers and takes over existing AKS clusters (in the same resource group). After the installation, you need apply the following change to enable RBAC access (read-only) to each new AKS cluster.
```sh
kubectl create -f https://raw.githubusercontent.com/2-alchemists/krossboard/master/tooling/setup/k8s/clusterrolebinding-aks.yml
```

## Other Resources
* [Discover and explore Krossboard analytics and data export]({{< relref "02_analytics-and-data-export" >}})
* [Setup Krossboard for Amazon EKS]({{< relref "50_deploy-for-amazon-eks" >}})
* [Setup Krossboard for Google GKE]({{< relref "20_deploy-for-google-gke" >}})
* [Setup Krossboard for Cross-Cloud or On-premises Kubernetes]({{< relref "60_deploy-for-cross-cloud-and-on-premises-kubernetes" >}})