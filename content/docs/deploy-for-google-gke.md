+++
title = "Setup Krossboard for Google GKE"
description = ""
weight = 30
draft = false
bref = ""
toc = true 
+++

On Google Compute Platform (GCP), Krossboard works as a standalone Compute Engine instance.

Each instance works on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. This means that, once deployed within a project, it can discover and handle all your GKE clusters belonging to that project. 

To ease its deployment, Krossboard is published as public GCP images ready to use.

This document does walk you through a step-by-step procedure to deploy and configure an instance of Krossboard for a GCP project. It would require you a couple of minutes. Promises.

## Before you begin
This installation guide assumes that:

* You have a basic level of practice with GCP.
* You have a GCP account with at least an editor level of access to a project.
* You have access to a Linux terminal with [gcloud](https://cloud.google.com/sdk) installed and configured to get access o your GCP project. Or, alternatively, you may use [Google Cloud Shell](https://cloud.google.com/shell).
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal.

> All the below steps are achieved from a terminal. Open a terminal to get ready.

## Deploy a Krossboard instance
The set of commands below shall deploy, in a couple of minutes, an instance of Krossboard for a given project.

Before running the commands, it's important to review and set the following variables appropriately: 
  * The variable `KB_IMAGE` shall be set with a valid Krossboard image (see the [list of available images]({{< relref "/docs/releases" >}})).
  * Variables starting `GCP_` to ensure that it corresponds your target environments.
  * A `g1-small` instance is a good starting point, unless you have 10+ GKE clusters with many namespaces in the same project. Either way, think to regularly check the metrics of the instance to adapt your choice if needed.

```bash
# user-provided parameters
GCP_PROJECT="my-gke-project"
GCP_ZONE="us-central1-a"
GCP_INSTANCE_TYPE="g1-small" 
KB_IMAGE="krossboard-beta-v20200726t1595767620"

# first create a service account for Krossboard
sa_name="krossboard-sa-$(date +%Y%m%d%H%M%S)"
gcloud iam service-accounts create $sa_name --display-name $sa_name
sa_email=$(gcloud iam service-accounts list --filter="NAME:$sa_name" --format="value(email)")
gcloud projects add-iam-policy-binding "$GCP_PROJECT" --member="serviceAccount:$sa_email" --role='roles/container.viewer'

# start the instance with the created service account
gcloud compute instances create ${KB_IMAGE} \
      --scopes=https://www.googleapis.com/auth/cloud-platform \
      --project=${GCP_PROJECT} \
      --zone=${GCP_ZONE} \
      --machine-type=${GCP_INSTANCE_TYPE} \
      --service-account="$sa_email" \
      --image=${KB_IMAGE} \
      --image-project=krossboard-factory \
      --tags=krossboard-server

# enable access to the Krossboard UI (HTTP, port 80)
gcloud compute firewall-rules create krossboard-allow-http \
    --project=${GCP_PROJECT} \
    --direction=INGRESS \
    --priority=1000 --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=krossboard-server      
```

> if prompted, answer `y`es to enable Compute Engine API.

## Get Access to Krossboard UI
Open a browser tab and point it to this URL `http://KROSSBOARD_IP/`, changing `KROSSBOARD_IP` to the IP address of the Krossboard instance (can be get from the GCP console). 

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