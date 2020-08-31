+++
title = "Setup Krossboard for Google GKE clusters"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Google Compute Platform (GCP), Krossboard works as a standalone Compute Engine instance. Each instance discovers and handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. This means that, once deployed within a project, it can discover and handle all your GKE clusters belonging to that project. 

This guide shows how to setup Krossboard for a given GCP project in a couple of minutes.

## Before you begin
First note that Krossboard is published as ready-to-use GCP images. This release approach aims to make its deployment as simple than creating a GCP virtual machine.

This installation guide assumes that:

* You have a basic level of practice with GCP.
* You have a GCP account with at least an editor level of access to a project. The editor role is needed to create and configure your Krossboard instance. **Krossboard itself needs _read-only access_ to your GKE clusters**.
* You have access to a Linux terminal with [gcloud](https://cloud.google.com/sdk) installed and configured to get access o your GCP project. Or, alternatively, you may use [Google Cloud Shell](https://cloud.google.com/shell).
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal.

## Deploy a Krossboard instance
The commands below shall deploy an instance of Krossboard in a couple of minutes.

Before launching the installation, review and set the following variables suitably:
  * The variable `GCP_PROJECT` sets the ID of the target project (i.e. where your GKE clusters are located).
  * The variable `GCP_ZONE` sets the deployment zone (default is `us-central1-a`). 
  * The variable `GCP_INSTANCE_TYPE` sets the instance type (default is `g1-small` -- what should be sufficient unless the target project holds a big number of GKE clusters along with many namespaces).

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