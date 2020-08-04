+++
title = "Deploy Krossboard for Azure AKS"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure, Krossboard works as a standalone virtual machine. 

Each instance can automatically discovers and handles all AKS clusters located in the same resource group. 

This guide describes step-by-step how to deploy and configure a Krossboard instance. 


## Before you begin
First note that Krossboard is published through an [Azure Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/shared-image-galleries). 

This installation guide assumes that:

* You have at least a basic level of practice with Azure concepts.
* You have at a least a **Contributor** access to your Azure subscription
* You have access to a Linux terminal (or Cloud Shell) where you can use Azure CLI.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal (or Cloud Shell).


### Sign in Azure via a Terminal
Open a terminal and sign in to Azure; this step is not necessary if you're using Azure Cloud Shell.

```sh
az login
```

Next run the following commands, and check that each of them completes successfully.

```sh
TENANT_ID=$(az account show --query "tenantId" | cut -d'"' -f2)
SUBSCRIPTION_ID=$(az account show --query id | cut -d'"' -f2)
echo -e "TENANT_ID: $TENANT_ID\nSUBSCRIPTION_ID: $SUBSCRIPTION_ID"
```

### Configure access to the Krossboard's Image Gallery
During this step, you would confirm that you want to access to resources located in the Krossboard's Shared Image Gallery in Azure.


Open a browser and point it to the following URL, while making sure to replace `TENANT_ID` with the value retrieved in the previous step. 

> https://login.microsoftonline.com/**TENANT_ID**/oauth2/authorize?client_id=72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0&response_type=code&redirect_uri=https%3A%2F%2Fwww.microsoft.com%2F

The following commands actually enable activate your access to the gallery. 

Replace `YOUR_AKS_GROUP` with the name of the resource group in which your AKS clusters are (will be) located.

```sh
AKS_GROUP="YOUR_AKS_GROUP"
KB_PROVIDER='9c88e487-60e8-43e5-983b-71133e91669a'
KB_PROVIDER_SUB='89cdfb38-415e-4612-9260-6d095914713d'
KB_CONSUMER='72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0'
KB_CONSUMER_PASS='3R5Cn7CZB5wiVY-2-T2S.G3RLTfJ_cE.15'
az role assignment create -g $AKS_GROUP --assignee $KB_CONSUMER --role "Contributor" 
az login --service-principal -t"$KB_PROVIDER" -u"$KB_CONSUMER"  -p"$KB_CONSUMER_PASS"
az login --service-principal -t"$TENANT_ID" -u"$KB_CONSUMER"  -p"$KB_CONSUMER_PASS"
```

## Start a Krossboard instance
> Before proceeding with next steps, make sure that the active Azure session is your main account (and not the service principal activated in the previous step).
> ```sh
> az login --tenant $TENANT_ID
> ```

Once logged in again with your Azure account, start an instance of Krossboard as below.
  * You can set another name for the instance if wished (see the value of `VM_NAME`). 
  * The option `--generate-ssh-keys` indicates to use your local ssh keys for the instance. 
  * If no key does exist, the Azure CLI does generate one. The ssh user would be `azureuser` (see option `--admin-username`)

```sh
VM_NAME="krossboard-`date +%F-%s`"
az vm create \
  -g $AKS_GROUP \
  -n $VM_NAME \
  --image "/subscriptions/$KB_PROVIDER_SUB/resourceGroups/krossboard-release/providers/Microsoft.Compute/galleries/KrossboardRelease/images/Krossboard" \
  --location centralus \
  --admin-username azureuser \
  --generate-ssh-keys \
  --assign-identity
```

## Configure permissions

Set required permissions (Azure RBAC) enabling Krossboard to discover AKS clusters in the given resource group.

```sh
VM_PID=$(az vm get-instance-view -g $AKS_GROUP -n $VM_NAME --query 'identity.principalId' | cut -d'"' -f2)
az role assignment create -g $AKS_GROUP --assignee $VM_PID --role "Managed Applications Reader" 
az role assignment create -g $AKS_GROUP --assignee $VM_PID --role "Azure Kubernetes Service Cluster User Role" 
```

Finally, set required permissions (AKS RBAC) to retrieve metrics from AKS clusters:
  * [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) must be installed and accessible from the current terminal.
  * This step is required for each AKS cluster.
    ```sh
    kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
    ```
  * The following example lists all existing AKS clusters in the given resource group and applies the required settings on them.

    ```sh
    AKS_CLUSTERS=$(az aks list -g $AKS_GROUP --query "[].name"  -otsv)
    for cluster in $AKS_CLUSTERS; do
      az aks get-credentials -g $AKS_GROUP -n $cluster
      kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
    done
    ```

## Get Access to Krossboard UI
Get the IP address of the instance via the Azure portal or via the command line.

```sh
KROSSBOARD_IP=$(az vm list-ip-addresses -g $AKS_GROUP -n $VM_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)
echo $KROSSBOARD_IP
```
Open a browser tab and point it to `http://$KROSSBOARD_IP/`, while replacing **$KROSSBOARD_IP** accordingly.

Here are the default credentials to sign in:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible.
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).