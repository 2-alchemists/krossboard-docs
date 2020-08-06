+++
title = "Deploy Krossboard for Azure AKS"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure, Krossboard works as a standalone virtual machine. 

Each instance can automatically discover and handle all AKS clusters located in the same resource group. 

This guide describes step-by-step how to deploy and configure a Krossboard instance. 


## Before you begin
First note that Krossboard is published through an [Azure Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/shared-image-galleries). 

This installation guide assumes that:

* You have at least a basic level of practice with Azure concepts.
* You have at a least a **Contributor** access to your Azure subscription
* You have access to a Linux terminal (or Cloud Shell) where you can use Azure CLI.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal (or Cloud Shell).


### Sign in to Azure via a Terminal
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


Open a browser and point it to the following URL, while making sure to replace `$TENANT_ID` with the value retrieved in the previous step. 

> https://login.microsoftonline.com/**$TENANT_ID**/oauth2/authorize?client_id=72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0&response_type=code&redirect_uri=https%3A%2F%2Fwww.microsoft.com%2F

The following commands actually enable activate your access to the gallery. 

Replace `YOUR_AKS_GROUP` with the name of the resource group in which your AKS clusters are (will be) located.

```sh
AKS_GROUP="YOUR_AKS_GROUP"
KB_PROVIDER_ID='9c88e487-60e8-43e5-983b-71133e91669a'
KB_PROVIDER_SUB='89cdfb38-415e-4612-9260-6d095914713d'
KB_CONSUMER_ID='72dd7144-7fb7-4f5c-ac6f-8cf276d2a0b0'
KB_CONSUMER_PASS='3R5Cn7CZB5wiVY-2-T2S.G3RLTfJ_cE.15'
az role assignment create -g $AKS_GROUP --assignee $KB_CONSUMER_ID --role "Contributor" 
az login --service-principal -t"$KB_PROVIDER_ID" -u"$KB_CONSUMER_ID"  -p"$KB_CONSUMER_PASS"
az login --service-principal -t"$TENANT_ID" -u"$KB_CONSUMER_ID"  -p"$KB_CONSUMER_PASS"
KB_ACCOUNT_USERNAME=$(az account show --query "user.name" | cut -d'"' -f2)
```

## Start a Krossboard instance
An instance of Krossboard can be started as below.
  * You can set other values for `VM_NAME` and `VM_SIZE`. A `Standard_B1ms`size VM is a good starting unless you have 10+ AKS clusters with many namespaces in the same resource group. Either way, think to regularly check the metrics of the instance to adapt your choice if applicable.
  * The option `--generate-ssh-keys` indicates to generate (if missing locally) a SSH key pair for the instance. The ssh user would be `azureuser` (see `--admin-username`).

```sh
VM_NAME="krossboard-`date +%F-%s`"
VM_SIZE='Standard_B1ms'

az vm create -g $AKS_GROUP \
  -n $VM_NAME \
  -- $VM_SIZE \
  --image "/subscriptions/$KB_PROVIDER_SUB/resourceGroups/krossboard-release/providers/Microsoft.Compute/galleries/KrossboardRelease/images/Krossboard" \
  --location centralus \
  --admin-username azureuser \
  --generate-ssh-keys \
  --assign-identity
```

## Configure permissions
> Before proceeding with next steps, make sure that the active Azure session is your main account (and not the service principal activated in the previous step).
> ```sh
> az logout --username $KB_ACCOUNT_USERNAME
> az account set --subscription $SUBSCRIPTION_ID
> az account list -otable
> ```

Set required permissions (Azure RBAC) to discover AKS clusters in a given resource group.

```sh
VM_SP=$(az vm get-instance-view -g $AKS_GROUP -n $VM_NAME --query 'identity.principalId' | cut -d'"' -f2)
az role assignment create -g $AKS_GROUP --assignee $VM_SP --role "Managed Applications Reader" 
az role assignment create -g $AKS_GROUP --assignee $VM_SP --role "Azure Kubernetes Service Cluster User Role" 
```

Finally, set required permissions (AKS RBAC) to retrieve metrics from AKS clusters:
  * [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) must be installed and accessible from the current terminal.
  * This step is required for each AKS cluster. All the needed permissions are read-only permissions on nodes and pods metrics.
    ```sh
    kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
    ```
  * The following example lists all existing AKS clusters in a resource group and applies the required settings on them.

    ```sh
    AKS_CLUSTERS=$(az aks list -g $AKS_GROUP --query "[].name"  -otsv)
    for cluster in $AKS_CLUSTERS; do
      az aks get-credentials -g $AKS_GROUP -n $cluster
      kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
    done
    ```

## Get Access to Krossboard UI
The Krossboard web interface is available port `80` by default. To access it we need to a set security group to the VM to enable access to this port.

```sh
KB_SG=krossboard-sg
VM_NICS=$(az vm nic list -g $AKS_GROUP --vm-name=$VM_NAME --query "[0].id" -otsv | cut -d'"' -f2)
az network nsg create --resource-group $AKS_GROUP -l centralus -n $KB_SG
az network nsg rule create -g $AKS_GROUP -n ${KB_SG}-rule --nsg-name $KB_SG --protocol tcp --priority 1000 --destination-port-range 80    
az network nic update --network-security-group $KB_SG --ids $VM_NICS
```

Get the IP address of the instance (it's also visible on the Azure portal).

```sh
KROSSBOARD_IP=$(az vm list-ip-addresses -g $AKS_GROUP -n $VM_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)
echo $KROSSBOARD_IP
```
Open a browser tab and point it to `http://$KROSSBOARD_IP/`, changing `$KROSSBOARD_IP` to the IP address of the Krossboard instance.

The default username and password to sign in are:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible.
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).