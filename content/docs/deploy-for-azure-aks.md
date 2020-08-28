+++
title = "Deploy Krossboard for Azure AKS clusters"
description = ""
weight = 30
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure, Krossboard works as a standalone virtual machine. 

Each instance works on a per [resource group](https://docs.microsoft.com/azure/azure-resource-manager/management/manage-resource-groups-portal) basis. This means that, once deployed within a resource group, it can discover and handle all your AKS clusters belonging to that group.

This guide describes step-by-step how to deploy and configure a Krossboard instance. 


## Before you begin
It's important to note that Krossboard is published through an [Azure Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/shared-image-galleries). 

This installation guide assumes that:

* You have at least a basic level of practice with Azure concepts.
* You have at a least a **Contributor** access to your Azure subscription
* You have access to a Linux terminal (or [Azure Cloud Shell](https://azure.microsoft.com/features/cloud-shell/)) where you can use Azure CLI.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal.

### Sign in to Azure
Open a terminal and perform the following commands to sign in to Azure and export variables required during the installation.

```sh
az login
export AZURE_TENANT_ID=$(az account show --query "tenantId" | cut -d'"' -f2)
export AZURE_SUBSCRIPTION_ID=$(az account show --query id | cut -d'"' -f2)
echo -e "AZURE_TENANT_ID: $AZURE_TENANT_ID\nAZURE_SUBSCRIPTION_ID: $AZURE_SUBSCRIPTION_ID"
```

### Consent to use Krossboard Image Gallery
Azure requires that you consent to use a Image gallery from a third party.

Open a web browser and point it to the following URL. Change `$AZURE_TENANT_ID` with your tenant ID (see the above steps). 

> https://login.microsoftonline.com/**$AZURE_TENANT_ID**/oauth2/authorize?client_id=72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0&response_type=code&redirect_uri=https%3A%2F%2Fwww.microsoft.com%2F


## Deploy a Krossboard instance
Before running the commands to deploy your instance of Krossboard, it's important to review the following:
  * The variable `AZURE_GROUP` sets the name of the resource group in which your AKS clusters are located.
  * The variable `KB_AZURE_VM_NAME` sets the name of the instance (default is automatically generated).
  * The variable `KB_AZURE_LOCATION` sets the deployment location (default is `centralus`). See the [list of regions with available images]({{< relref "/docs/releases" >}})).
  * (Optional) Set the variable `KB_AZURE_VM_SIZE` with the needed VM size (default is `Standard_B1ms`, what is a good starting unless you have 10+ AKS clusters with many namespaces in the target resource group). 
  * The installation uses the option `--generate-ssh-keys` of Azure CLI to use the local SSH key pair for the instance. The associated SSH username would be `azureuser`.

```sh
# deployment parameters
export AZURE_GROUP="YOUR_AZURE_GROUP_WITH_AKS"
export KB_AZURE_VM_NAME="krossboard-`date +%F-%s`"
export KB_AZURE_VM_SIZE='Standard_B1ms'
export KB_AZURE_LOCATION='centralus'
curl -so krossboard_azure_install.sh \
    https://krossboard.app/artifacts/setup/krossboard_azure_install.sh && \
    bash ./krossboard_azure_install.sh
```

On success a summary of the installation shall be displayed as below:
```
=== Summary the Krossboard instance ===
Instance Name => krossboard-2020-08-18-1595880565
Resource Group => prod
Krossboard UI => http://1.2.3.4/
```

### Handle new AKS clusters
During the installation, the Krossboard deployment script discovers and takes over existing AKS clusters (in the same resource group). After the installation, you need apply the following change to enable RBAC access (read-only) to each new AKS cluster. 
```sh
kubectl create -f https://krossboard.app/artifacts/setup/k8s/clusterrolebinding-aks.yml
```

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL displayed at the end of the installation script. **Note:** It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

The IP address of the instance is displayed at the end of the installation script. You can also get it on the Azure portal.

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
* [Setup Krossboard for Google GKE]({{< relref "deploy-for-google-gke" >}})