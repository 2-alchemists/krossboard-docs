+++
title = "Setup Krossboard for Google GKE"
description = ""
weight = 30
draft = false
bref = ""
toc = true 
+++

On Google Compute Platform (GCP), Krossboard works as a standalone Compute Engine instance.
Each instance discovers and handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. 

This guide describes step-by-step how to deploy and configure an instance of Krossboard for a GCP project. 

## Before you begin
This guide should be straightforward to follow, assuming that:

* You have a basic level of practice with GCP concepts.
* You have access to [Google Cloud Console](https://console.cloud.google.com/).
* You have access to a GCP project with sufficient permissions to:
  * Create a [GCP service account](https://cloud.google.com/iam/docs/understanding-service-accounts) for Krossboard.
  * Assign GCP predefined roles to a GCP service account.
  * Use Google Cloud Console, though the steps can be adapted for a scripted/automated deployment.

> Note that all the below steps are achieved from the Google Cloud Console.

## Step 1: Select a GCP project
Krossboard discovers and handles GKE clusters as a project basics. The clusters can be spread accross different regions and zones in that project.

 On the Cloud Console, select a project as follows.

 ![](/images/docs/gcp-select-project.png)


## Step 2: Create an IAM service account for Krossboard
Each Krossboard instance needs to have a the role of **Kubernetes Engine Viewer** (i.e. read-only access to GKE resources).
This role is assigned to it through a service account created as below on the Google Cloud Console.

* On the Navigation menu (![GCP Navigation Menu](/images/docs/gcp-nagivation-menu.png)), select **IAM & Admin -> Service accounts**.
* Click **Create Service Account**.
* Name the **Service account name** and, optionally, provide a description.
* Click **Create**.
* Click **Select a role**.
* In the filter, type **Kubernetes Engine Viewer**.
* Select the matched entry.
* Click **Continue** and then **Done** to complete the creation.

## Step 3: Deploy a Krossboard instance

From the Google Cloud Console:

* On the Navigation menu (![GCP Navigation Menu](/images/docs/gcp-nagivation-menu.png)), click **Compute Engine > VM instances**.
* Click **Create**.
* Name the instance (e.g. `krossboard`).
* Select a **Region** and a **Zone** if needed.
* For **Machine Type**, if you do have a maximum of 3 clusters, a `g1-small` instance would be sufficient.
  Otherwise we do recommend to start with a `n1-standard-1` instance.
* On **Boot disk**, click **Change**.
* For **Service account**, select the service account created previously.
* Check **Allow HTTP traffic**.
* Click **Done**.
* Click **Create** to start the instance.

## Step 4: Get Access to Krossboard UI
Open a browser tab and point it to this URL `http://krossboard-ip/`.  Replace **krossboard-ip** with the IP address of the created Krossboard instance.

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

It's highly recommended to change this default password as soon as possible. To do so, log into the instance through SSH and run this command:

```
sudo /opt/krossboard/bin/krossboard-change-passwd
```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).