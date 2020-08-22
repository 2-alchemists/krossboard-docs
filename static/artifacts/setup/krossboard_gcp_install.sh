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

echo "==> Checking deployment parameters..."
curl -so krossboard_default.sh https://krossboard.app/artifacts/setup/krossboard_default.sh && \
  source ./krossboard_default.sh

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

echo -e "\e[32m==> Summary of installation settings:\e[0m"
echo "    KB_GCP_IMAGE => $KB_GCP_IMAGE"
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

echo "==> Creating a GCP service account for Krossboard..."
sa_name="krossboard-sa-$(date +%Y%m%d%H%M%S)"
gcloud iam service-accounts create $sa_name --display-name $sa_name
sa_email=$(gcloud iam service-accounts list --filter="NAME:$sa_name" --format="value(email)")
gcloud projects add-iam-policy-binding "$GCP_PROJECT" --member="serviceAccount:$sa_email" --role='roles/container.viewer'

echo "==> Start a Krossboard instance..."
gcloud compute instances create ${KB_GCP_IMAGE} \
      --scopes=https://www.googleapis.com/auth/cloud-platform \
      --project=${GCP_PROJECT} \
      --zone=${GCP_ZONE} \
      --machine-type=${GCP_INSTANCE_TYPE} \
      --service-account="$sa_email" \
      --image=${KB_GCP_IMAGE} \
      --image-project=krossboard-factory \
      --tags=krossboard-server

echo "==> enable access to the Krossboard UI (HTTP, port 80)..."
gcloud compute firewall-rules create krossboard-allow-http \
    --project=${GCP_PROJECT} \
    --direction=INGRESS \
    --priority=1000 --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=krossboard-server   