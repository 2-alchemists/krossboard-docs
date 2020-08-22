#!/bin/bash
# ------------------------------------------------------------------------ #
# File: krossboard_azure_install.sh                                        #
# Creation: August 22, 2020                                                #
# Copyright (c) 2020 2Alchemists SAS                                       #
#                                                                          #
# This file is part of Krossboard (https://krossboard.app/).               #
#                                                                          #
# The tool is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# Krossboard terms of use: https://krossboard.app/legal/terms-of-use/      #
#--------------------------------------------------------------------------#

set -e

echo "==> Checking deployment parameters..."
curl -so krossboard_default.sh https://krossboard.app/artifacts/setup/krossboard_default.sh && \
  source ./krossboard_default.sh

if [ -z "$KB_AZURE_GROUP" ]; then
  echo -e "\e[31mPlease set the KB_AZURE_GROUP variable with the target Azure resource group\e[0m"
  exit 1
fi

if [ -z "$KB_AZURE_VM_NAME" ]; then
  KB_AZURE_VM_NAME="krossboard-`date +%F-%s`"
  echo -e "\e[35mVM_NAME not set, using => $KB_AZURE_VM_NAME\e[0m"
fi

if [ -z "$KB_AZURE_VM_SIZE" ]; then
  KB_AZURE_VM_SIZE="$KB_AZURE_VM_SIZE_DEFAULT" 
  echo -e "\e[35mKB_AZURE_VM_SIZE not set, using => $KB_AZURE_VM_SIZE\e[0m"
fi

echo -e "\e[32m==> Summary of installation settings:\e[0m"
echo "    KB_AZURE_VM_NAME => $KB_AZURE_VM_NAME"
echo "    KB_AZURE_VM_SIZE => $KB_AZURE_VM_SIZE"
echo "    KB_AZURE_GROUP => $KB_AZURE_GROUP"

while true; do
    echo -e '\e[32mProceed with the installation? y/n\e[0m'
    read yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# now only accept bound variables
set -u

echo "==> Activating permissions to access to the Krossboard Image gallery on Azure..."
az role assignment create -g $KB_AZURE_GROUP --assignee $KB_AZURE_CONSUMER_ID --role "Contributor" 
az login --service-principal -t"$KB_AZURE_PROVIDER_ID" -u"$KB_AZURE_CONSUMER_ID"  -p"$KB_AZURE_CONSUMER_PASS"
az login --service-principal -t"$AZURE_TENANT_ID" -u"$KB_AZURE_CONSUMER_ID"  -p"$KB_AZURE_CONSUMER_PASS"
KB_ACCOUNT_USERNAME=$(az account show --query "user.name" | cut -d'"' -f2)

echo "==> Start a Krossboard instance..."
az vm create -g $KB_AZURE_GROUP \
  -n $KB_AZURE_VM_NAME \
  -- $KB_AZURE_VM_SIZE \
  --image "/subscriptions/$KB_AZURE_PROVIDER_SUB/resourceGroups/krossboard-release/providers/Microsoft.Compute/galleries/KrossboardRelease/images/Krossboard" \
  --location centralus \
  --admin-username azureuser \
  --generate-ssh-keys \
  --assign-identity

echo "==> Configure IAM permissions for the Krossboard instance..."
az logout --username $KB_ACCOUNT_USERNAME
az account set --subscription $AZURE_SUBSCRIPTION_ID
az account list -otable
VM_SP=$(az vm get-instance-view -g $KB_AZURE_GROUP -n $KB_AZURE_VM_NAME --query 'identity.principalId' | cut -d'"' -f2)
az role assignment create -g $KB_AZURE_GROUP --assignee $VM_SP --role "Managed Applications Reader" 
az role assignment create -g $KB_AZURE_GROUP --assignee $VM_SP --role "Azure Kubernetes Service Cluster User Role"

echo "==> Discovery and taking over existing AKS clusters..."
CURRENT_CLUSTERS=$(az aks list -g $KB_AZURE_GROUP --query "[].name"  -otsv)
for cluster in $CURRENT_CLUSTERS; do
    az aks get-credentials -g $KB_AZURE_GROUP -n $cluster
    kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
done

echo "==> Enable HTTP access to the Krossboard web interface..."
KB_SG=krossboard-sg
VM_NICS=$(az vm nic list -g $KB_AZURE_GROUP --vm-name=$KB_AZURE_VM_NAME --query "[0].id" -otsv | cut -d'"' -f2)
az network nsg create --resource-group $KB_AZURE_GROUP -l centralus -n $KB_SG
az network nsg rule create -g $KB_AZURE_GROUP -n ${KB_SG}-rule --nsg-name $KB_SG --protocol tcp --priority 1000 --destination-port-range 80    
az network nic update --network-security-group $KB_SG --ids $VM_NICS

echo "==> Getting the IP address of the Krossboard install..."
KB_HOSTIP=$(az vm list-ip-addresses -g $KB_AZURE_GROUP -n $KB_AZURE_VM_NAME --query [0].virtualMachine.network.publicIpAddresses[0].ipAddress -o tsv)
echo $KB_HOSTIP