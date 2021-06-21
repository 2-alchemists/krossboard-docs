+++
title = "Setup for Google GKE Clusters"
description = ""
weight = 20
draft = false
bref = ""
toc = true
aliases = ["/docs/deploy-for-google-gke/"]
+++

On GCP, Krossboard is available as ready-to-use virtual machine images. This release approach makes its deployment as simple than creating a GCP virtual machine.

Once deployed, the Krossboard instance is able to automatically discover and handle your GKE clusters. By default, the discovery works on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis, meaning that the instance does automatically discover and handle all your GKE clusters belonging to the project in which it's deployed.

This guide shows how to setup Krossboard for a given GCP project. It'll take you a couple of minutes to make it up and running.

## Before you begin
This installation guide assumes that:

* You have subscribed to a [Krossboard offer](http://localhost:1313/#pricing) that includes the use of cloud images.
* You have a basic level of practice with GCP.
* You have a GCP account with at least an editor level of access to a project. The editor role is needed to create and configure your Krossboard instance; Krossboard by itself needs read-only access to your GKE clusters.
* You have access to a `bash >=4` terminal with [gcloud](https://cloud.google.com/sdk) installed and configured to get access o your GCP project. Or, alternatively, you may use [Google Cloud Shell](https://cloud.google.com/shell).
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal.

## Deploy a Krossboard instance
The commands below shall deploy an instance of Krossboard in a couple of minutes.

Before launching the installation, review and set the following variables suitably:
  * The variable `GCP_PROJECT` sets the ID of the target project (i.e. where your GKE clusters are located).
  * The variable `GCP_ZONE` sets the deployment zone (default is `us-central1-a`). 
  * The variable `GCP_INSTANCE_TYPE` sets the instance type (default is `g1-small`).

```bash
# user-provided parameters
export GCP_PROJECT="my-gke-project"
export GCP_ZONE="us-central1-a"
export GCP_INSTANCE_TYPE="g1-small" 
curl -so krossboard_gcp_install.sh \
    https://raw.githubusercontent.com/2-alchemists/krossboard/master/tooling/setup/krossboard_gcp_install.sh && \
    bash ./krossboard_gcp_install.sh
```

> If you have the following prompt:
> ```
> API [compute.googleapis.com] not enabled on project [1062262466175]. 
> Would you like to enable and retry (this will take a few minutes)? 
> (y/N)?
> ```
>  Answer `y`es to enable Compute Engine API.

On success a summary of the installation shall be displayed as below:
```
=== Summary the Krossboard instance ===
Instance Name => krossboard-v20200818t1597750044-preview
Project => krossboard-demo
Krossboard UI => http://1.2.3.4/
```

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL displayed at the end of the installation script. 

> It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

Here are the default username and password to sign in:

* **Username:** `krossboard`
* **Password (default):** `Kr0sSB8qrdAdm`

> It's highly recommended to change this default password as soon as possible. 
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Troubleshooting
In case of problem, first checkout the [Troubleshooting Page]({{< relref "/docs/901_troubleshooting" >}}) for an initial investigation.

If the problem you're experiencing is not listed there, open a ticket on the [Krossboard GitHub Page](https://github.com/2-alchemists/krossboard/issues).

Alternatively, if you do have an active support contract, you can also send an email directly to our customer support service: `support at krossboard.app`.

## Other Resources
* [Krossboard Analytics and Data Export]({{< relref "02_analytics-and-data-export" >}})
* [Setup Krossboard for Amazon EKS]({{< relref "50_deploy-for-amazon-eks" >}})
* [Setup Krossboard for Azure AKS]({{< relref "30_deploy-for-azure-aks" >}})
* [Setup Krossboard for Cross-Cloud or On-premises Kubernetes]({{< relref "60_deploy-for-cross-cloud-and-on-premises-kubernetes" >}})