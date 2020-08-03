+++
title = "Deploy Krossboard for Azure AKS"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure, Krossboard works as a standalone virtual machine.

> Each instance of Krossboard automatically discovers and handles AKS clusters according to permissions assigned to it through Azure IAM roles. In order words, given an appropriate permission level, an instance of Krossboard can even discover and handle all the AKS clusters within a subscription.

This guide describes step-by-step how to deploy and configure a Krossboard instance. 


## Before you begin
Krossboard is published on Azure through a [Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/shared-image-galleries). 

This guide should be straightforward to follow, assuming that:

* You have a basic level of practice with Azure concepts.
* You have access via the Azure portal to an active subscription
* To setup a Krossboard instance it's required that your account have, at a minimum, permissions (1) to create and assign a managed identity to an Azure virtual machine; and (2) to assign Azure roles to a managed identity; (3) to deploy virtual machine via [Azure Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/shared-image-galleries).
* You a terminal access (or a Cloud Shell access) to the Azure subscription.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed on your terminal with an admin-level access to your AKS clusters.


### Enable Access to Krossboard Image Gallery
Open a browser and point it to the following URL: https://login.microsoftonline.com/YOUR_TENANT_ID/oauth2/authorize?client_id=72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0&response_type=code&redirect_uri=https%3A%2F%2Fwww.microsoft.com%2F. 
  
Make sure to replace `YOUR_TENANT_ID` in the URL with the tenant ID of your Azure account. You can retrieve the tenant ID of your account using this command: `az account show --query "tenantId"`

Then sign in the Azure portal and give the app registration access to the resource group where you want to create your Krossboard instance.

* Select the resource group and then select **Access control (IAM)**. 
* Under **Add role assignment** select **Add**.
* Under **Role**, type **Contributor**.
* Under **Assign access to:**, leave this as **Azure AD user, group, or service principal**.
* Under **Select** type `KrossboardRelease` then select it when it shows up in the list. When you are done, select Save.

### Configure access to the Image gallery
This step requires to be performed via a terminal or via Azure Cloud Shell. 

First make sure that you're logged with your mainAzure account. Otherwise run the following command to login (this step is not needed with Cloud Shell).

```sh
az login
```

The next command activates your credentials to access the Krossboard's Image gallery.

Replace `YOUR_TENANT_ID` with your main account Azure tenant ID.

```sh
az login --service-principal --tenant "YOUR_TENANT_ID" \
  -u "72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0" \
  -p "3R5Cn7CZB5wiVY-2-T2S.G3RLTfJ_cE.15"
```

## Start and configure a Krossboard instance

Replace the value of `YOUR_RESOURCE_GROUP` in the next commands with the name of the target resource group for Krossboard (i.e. group where your AKS clusters are located). You can also set another name.

```sh
RG_NAME="YOUR_RESOURCE_GROUP"
VM_NAME="krossboard-`date +%F-%s`"
az vm create \
  --resource-group $RG_NAME \
  --name $VM_NAME \
  --image '/subscriptions/89cdfb38-415e-4612-9260-6d095914713d/resourceGroups/krossboard-release/providers/Microsoft.Compute/galleries/KrossboardRelease/images/Krossboard' \
  --location centralus \
  --generate-ssh-keys
```

Logout to all sessions and sign in again with only your main Azure account.

```sh
az account clear
az login
```

Assign a managed identity to the instance

```sh
az vm identity assign -g $RG_NAME -n $VM_NAME
```

Assign IAM roles required for AKS clusters discovery.

```sh
VMPID=$(az vm get-instance-view -g $RG_NAME -n $VM_NAME --query 'identity.principalId' | cut -d'"' -f2)
az role assignment create -g $RG_NAME --assignee $VMPID \
  --role "Managed Applications Reader" 
az role assignment create -g $RG_NAME --assignee $VMPID \
  --role "Azure Kubernetes Service Cluster User Role" 
```

## Configure AKS RBAC to enable access to cluster metrics
At this stage we're almost done, but Krossboard is not yet allowed to retrieve metrics from discovered AKS clusters. The last step is to configure RBAC settings on each AKS cluster to enable the required permissions.

To ease that, Krossboard is released with a ready-to-use configuration file that can be applied as follows on your AKS clusters as below. This create a **ClusterRole** and an associated **ClusterRoleBinding** giving access to the target AKS cluster metrics.


```
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
```

## Get Access to Krossboard UI
Open a browser tab and point it to this URL `http://instance-addr/` while replacing **instance-addr** with the IP address of the Krossboard instance.

Here are credentials to log in:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. To do so, log into the instance through SSH and run this command:
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).