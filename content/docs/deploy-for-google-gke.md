+++
title = "Setup Krossboard for Google GKE"
description = ""
weight = 20
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
  * The variable `KB_GCP_IMAGE` shall be set with a valid Krossboard image (see the [list of available images]({{< relref "/docs/releases" >}})).
  * Variables starting `GCP_` to ensure that it corresponds your target environments.
  * A `g1-small` instance is a good starting point, unless you have 10+ GKE clusters with many namespaces in the same project. Either way, think to regularly check the metrics of the instance to adapt your choice if needed.

```bash
# user-provided parameters
export KB_GCP_IMAGE="krossboard-v20200818t1597750044-preview"
export GCP_PROJECT="my-gke-project"
export GCP_ZONE="us-central1-a"
export GCP_INSTANCE_TYPE="g1-small" 

curl -so krossboard_gcp_install.sh \
  https://krossboard.app/artifacts/setup/krossboard_gcp_install.sh && \
  bash ./krossboard_gcp_install.sh
```

> if prompted, answer `y`es to enable Compute Engine API.

## Get access to Krossboard UI
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