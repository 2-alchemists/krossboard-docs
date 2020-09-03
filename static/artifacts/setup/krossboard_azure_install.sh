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

echo "==> Checking prerequisites..."
if ! command -v kubectl &> /dev/null; then
  echo "\e[31m[ERROR] kubectl could not be found, please install it => https://kubernetes.io/docs/tasks/tools/install-kubectl/\e[0m"
  exit 1
fi

echo "==> Checking deployment parameters..."
curl -so /tmp/krossboard_default.sh https://krossboard.app/artifacts/setup/krossboard_default.sh && \
  source /tmp/krossboard_default.sh

if [ -z "$AZURE_GROUP" ]; then
  echo -e "\e[31m[ERROR] Please set the AZURE_GROUP variable with the target Azure resource group\e[0m"
  exit 1
fi

if [ -z "$KB_AZURE_LOCATION" ]; then
  KB_AZURE_LOCATION="$KB_AZURE_LOCATION_DEFAULT"
  echo -e "\e[35mKB_AZURE_LOCATION not set, using => $KB_AZURE_LOCATION\e[0m"
fi

if [ -z "$KB_AZURE_VM_NAME" ]; then
  KB_AZURE_VM_NAME="krossboard-`date +%F-%s`"
  echo -e "\e[35mVM_NAME not set, using => $KB_AZURE_VM_NAME\e[0m"
fi

if [ -z "$KB_AZURE_VM_SIZE" ]; then
  KB_AZURE_VM_SIZE="$KB_AZURE_VM_SIZE_DEFAULT" 
  echo -e "\e[35mKB_AZURE_VM_SIZE not set, using => $KB_AZURE_VM_SIZE\e[0m"
fi

echo -e "\e[32m==> Installation settings:\e[0m"
echo "    KB_AZURE_VM_NAME => $KB_AZURE_VM_NAME"
echo "    KB_AZURE_VM_SIZE => $KB_AZURE_VM_SIZE"
echo "    AZURE_GROUP => $AZURE_GROUP"
echo "    KB_AZURE_LOCATION => $KB_AZURE_LOCATION"

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
echo "==> Activating permissions to connect to Krossboard Image gallery on Azure..."
az role assignment create -g $AZURE_GROUP --assignee $KB_AZURE_CONSUMER_ID --role "Contributor"
# first backing off the main session before changing the logged user
AZ_CRED_BKP_DIR="$HOME/.azure-kb-backup-`date +%F-%s`"
mkdir -p ${AZ_CRED_BKP_DIR} && cp -pr $HOME/.azure/* ${AZ_CRED_BKP_DIR}/
az login --service-principal -t"$KB_AZURE_PROVIDER_TENANT_ID" -u"$KB_AZURE_CONSUMER_ID" -p"$KB_AZURE_CONSUMER_PASS"
az login --service-principal -t"$AZURE_TENANT_ID" -u"$KB_AZURE_CONSUMER_ID" -p"$KB_AZURE_CONSUMER_PASS"

echo "==> Starting a Krossboard instance..."
az vm create -g $AZURE_GROUP \
  -n "$KB_AZURE_VM_NAME" \
  --size $KB_AZURE_VM_SIZE \
  --image "$KB_AZURE_IMAGE" \
  --location $KB_AZURE_LOCATION \
  --admin-username azureuser \
  --generate-ssh-keys
  

echo "==> Configure IAM permissions for the instance..."
# restore the main session before continuing
cp -pr ${AZ_CRED_BKP_DIR}/* $HOME/.azure/ && rm -rf ${AZ_CRED_BKP_DIR}/
az vm identity assign -n $KB_AZURE_VM_NAME -g $AZURE_GROUP --scope /subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$AZURE_GROUP
KB_PRINCIPAL_ID=$(az vm show -g $AZURE_GROUP -n $KB_AZURE_VM_NAME --query "identity.principalId" -otsv)
az role assignment create -g $AZURE_GROUP --assignee $KB_PRINCIPAL_ID --role "Managed Applications Reader" 
az role assignment create -g $AZURE_GROUP --assignee $KB_PRINCIPAL_ID --role "Azure Kubernetes Service Cluster User Role"

echo "==> Discovery existing AKS clusters..."
CURRENT_CLUSTERS=$(az aks list -g $AZURE_GROUP --query "[].name" -otsv)
for cluster in $CURRENT_CLUSTERS; do
    az aks get-credentials -g $AZURE_GROUP -n $cluster
    kubectl create -f https://krossboard.app/artifacts/setup/k8s/clusterrolebinding-aks.yml
done

echo "==> Enable HTTP access to Krossboard UI..."
KB_NSG_NAME="krossboard-nsg-$KB_AZURE_LOCATION"
KB_NSG_FOUND=$(az network nsg show -n "$KB_NSG_NAME" -g "$AZURE_GROUP" --query="name" -otsv || echo "KB_NSG_NOT_FOUND")
if [ "$KB_NSG_FOUND" != "$KB_NSG_NAME" ]; then
  echo -e "\e[35mCreating network security group for Krossboard ==> $KB_NSG_NAME\e[0m"
  az network nsg create -g $AZURE_GROUP -n $KB_NSG_NAME --location $KB_AZURE_LOCATION
  az network nsg rule create -g $AZURE_GROUP -n ${KB_NSG_NAME}-rule --nsg-name $KB_NSG_NAME --protocol tcp --priority 1000 --destination-port-range 80    
else
  echo -e "\e[35mUsing network security group ==> $KB_NSG_NAME\e[0m"
fi

echo -e "\e[35mAttaching the network security group to the instance...\e[0m"
KB_INSTANCE_NICS=$(az vm nic list -g "$AZURE_GROUP" --vm-name="$KB_AZURE_VM_NAME" --query "[0].id" -otsv | cut -d'"' -f2)
az network nic update --network-security-group "$KB_NSG_NAME" --ids "$KB_INSTANCE_NICS"

echo "==> Getting the IP address of the instance..."
KB_IP=$(az vm list-ip-addresses -g $AZURE_GROUP -n $KB_AZURE_VM_NAME --query='[0].virtualMachine.network.publicIpAddresses[0].ipAddress' -o tsv)
echo $KB_IP

echo -e "\e[1m\e[32m=== Summary the installation ==="
echo -e "Instance Name => $KB_AZURE_VM_NAME"
echo -e "Resource Group => $AZURE_GROUP"
echo -e "Location => $KB_AZURE_LOCATION"
echo -e "Krossboard UI => http://$KB_IP/"
echo -e "\e[0m"