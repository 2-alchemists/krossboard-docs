#!/bin/bash
# ------------------------------------------------------------------------ #
# File: krossboard_gcp_install.sh                                          #
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

if ! command -v gcloud &> /dev/null; then
  echo "\e[31m[ERROR] gcloud sdk could not be found, please install it => https://cloud.google.com/sdk\e[0m"
  exit 1
fi

echo "==> Checking deployment parameters..."
curl -so /tmp/krossboard_default.sh https://krossboard.app/artifacts/setup/krossboard_default.sh && \
  source /tmp/krossboard_default.sh

if [ -z "$KB_GCP_IMAGE" ]; then
  KB_GCP_IMAGE="$KB_GCP_IMAGE_DEFAULT" 
  echo -e "\e[35mKB_AZURE_VM_SIZE not set, using => $KB_GCP_IMAGE\e[0m"
fi

if [ -z "$GCP_PROJECT" ]; then
  GCP_PROJECT=$(gcloud config get-value project)
  echo -e "\e[35mGCP_PROJECT not set, using => $GCP_PROJECT (default)\e[0m"
fi

if [ -z "$GCP_ZONE" ]; then
  GCP_ZONE=$(gcloud config get-value compute/zone)
  echo -e "\e[35mGCP_ZONE not set, using => $GCP_ZONE (default)\e[0m"
fi

if [ -z "$GCP_INSTANCE_TYPE" ]; then
  GCP_INSTANCE_TYPE="g1-small" 
  echo -e "\e[35mGCP_INSTANCE_TYPE not set, using => $GCP_INSTANCE_TYPE\e[0m"
fi

if [ "$KB_INSTANCE_NAME" == "" ]; then
  KB_INSTANCE_NAME="$KB_GCP_IMAGE-`date +%F-%s`"
fi

echo -e "\e[32m==> Installation settings:\e[0m"
echo "    KB_GCP_IMAGE => $KB_GCP_IMAGE"
echo "    KB_INSTANCE_NAME => $KB_INSTANCE_NAME"
echo "    GCP_PROJECT => $GCP_PROJECT"
echo "    GCP_ZONE => $GCP_ZONE"
echo "    GCP_INSTANCE_TYPE => $GCP_INSTANCE_TYPE"

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
GCLOUD_CMD="gcloud --project=$GCP_PROJECT"
echo "==> Configuring IAM permissions for Krossboard..."
KB_SA_NAME='krossboard-sa'
KB_SA_EMAIL=$($GCLOUD_CMD iam service-accounts list --filter="name:$KB_SA_NAME@$GCP_PROJECT" --format="value(EMAIL)")
if [ "$KB_SA_EMAIL" != "" ]; then
  echo -e "\e[35mUsing service account ${KB_SA_NAME} => $KB_SA_EMAIL\e[0m"
else
  echo -e "\e[35mCreating a GCP service account ${KB_SA_NAME}...\e[0m"
  $GCLOUD_CMD iam service-accounts create $KB_SA_NAME --display-name $KB_SA_NAME
  retry=0
  until [ "$retry" -ge 15 ]; do
    KB_SA_EMAIL=$($GCLOUD_CMD iam service-accounts list --filter="name:$KB_SA_NAME@$GCP_PROJECT" --format="value(EMAIL)")
    if [ -z "$KB_SA_EMAIL" ]; then
      echo -e "\e[35mWaiting the service account to become ready...\e[0m"
      sleep 1
    else
      echo -e "\e[35mService account email => $KB_SA_EMAIL\e[0m"
      $GCLOUD_CMD projects add-iam-policy-binding "$GCP_PROJECT" --member="serviceAccount:$KB_SA_EMAIL" --role='roles/container.viewer'
      break
    fi
    sleep 1
    retry=$((retry+1)) 
  done
  if [ -z "$KB_SA_EMAIL" ]; then
    echo -e "\e[31m[ERROR] Failed getting created service account\e[0m"
    exit 1
  fi
fi

echo "==> Starting a Krossboard instance..."
$GCLOUD_CMD compute instances create "$KB_INSTANCE_NAME" \
      --scopes=https://www.googleapis.com/auth/cloud-platform \
      --zone="$GCP_ZONE" \
      --machine-type="$GCP_INSTANCE_TYPE" \
      --service-account="$KB_SA_EMAIL" \
      --image="$KB_GCP_IMAGE" \
      --image-project=krossboard-factory \
      --tags=krossboard-server

echo "==> Enable access to Krossboard UI (HTTP, port 80)..."
KB_FW_RULE='krossboard-allow-http'
KB_FW_RULE_FOUND=$($GCLOUD_CMD compute firewall-rules list --filter="name:$KB_FW_RULE"  --format="value(Name)")
if [ "$KB_FW_RULE_FOUND" != "$KB_FW_RULE" ]; then
  $GCLOUD_CMD compute firewall-rules create krossboard-allow-http \
      --direction=INGRESS \
      --priority=1000 --network=default \
      --action=ALLOW \
      --rules=tcp:80 \
      --source-ranges=0.0.0.0/0 \
      --target-tags=krossboard-server
fi

KB_IP=$($GCLOUD_CMD compute instances list --filter="name:$KB_INSTANCE_NAME" --format="value(EXTERNAL_IP)")

echo -e "\e[1m\e[32m=== Summary the Krossboard instance ==="
echo -e "Instance Name => $KB_INSTANCE_NAME"
echo -e "Project => ${GCP_PROJECT}"
echo -e "Krossboard UI => http://$KB_IP/"
echo -e "\e[0m"

   