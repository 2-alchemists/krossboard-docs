+++
title = "Setup Krossboard for Google GKE clusters"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Google Compute Platform (GCP), Krossboard works as a standalone Compute Engine instance. Each instance discovers and handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. This means that, once deployed within a project, it can discover and handle all your GKE clusters belonging to that project. 

This document does walk you through a step-by-step procedure to deploy and configure an instance of Krossboard for a GCP project. It would require you a couple of minutes. Promises.

## Before you begin
First note that Krossboard is published as ready-to-use GCP images. This release approach aims to make its deployment as simple than creating a GCP virtual machine.

This installation guide assumes that:

* You have a basic level of practice with GCP.
* You have a GCP account with at least an editor level of access to a project. The editor role is needed to create and configure your Krossboard instance. Krossboard itself requires only read-only access to your GKE clusters.
* You have access to a Linux terminal with [gcloud](https://cloud.google.com/sdk) installed and configured to get access o your GCP project. Or, alternatively, you may use [Google Cloud Shell](https://cloud.google.com/shell).
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal.

> All the below steps are achieved from a terminal. Open a terminal to get ready.

## Deploy a Krossboard instance
The set of commands below shall deploy, in a couple of minutes, an instance of Krossboard.

Before running the commands, it's important to review and set the variables starting `GCP_` to ensure that it corresponds your target environments. Note that a `g1-small` instance should be sufficient, unless you have a big number of GKE clusters along with many namespaces in the target region in the same project.

```bash
# user-provided parameters
export GCP_PROJECT="my-gke-project"
export GCP_ZONE="us-central1-a"
export GCP_INSTANCE_TYPE="g1-small" 
curl -so krossboard_gcp_install.sh \
    https://krossboard.app/artifacts/setup/krossboard_gcp_install.sh && \
    bash ./krossboard_gcp_install.sh
```

> if prompted, answer `y`es to enable Compute Engine API.

On success a summary of the installation shall be displayed as below:
```
=== Summary the Krossboard instance ===
Instance Name => krossboard-v20200818t1597750044-preview
Project => krossboard-demo
Krossboard UI => http://1.2.3.4/
```

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL displayed at the end of the installation script. **Note:** It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

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