+++
title = "Setup Krossboard for Google GKE"
description = ""
weight = 30
draft = false
bref = ""
toc = true 
+++

On Google Compute Platform (GCP), Krossboard works as a standalone compute virtual machine.
Each Krossboard instance discovers and handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. 

This guide describes step-by-step how to deploy and configure an instance of Krossboard for a GCP project. 

## Before you begin
This guide should be straightforward to follow, assuming that:

* You have a basic level of practice with GCP concepts.
* You have access to a GCP project with sufficient permissions to:
  * Create GCP IAM service accounts.
  * Assign GCP predefined roles to a GCP IAM service account.
  * Use GCP Cloud Console, though the steps can be adapted for a scripted/automated deployment.

> **Important:** Don't be confused, it's worth nothing that [GCP service accounts](https://cloud.google.com/iam/docs/understanding-service-accounts) and [Kubernetes services accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/) are two different concepts.

## Step 1: Select a GCP project
Krossboard discovers and handles GKE clusters as a project basics. The clusters can be spread accross different regions and zones in that project. 

 From GCP Cloud Console, select a project as follows.

 ![](/images/docs/gcp-select-project.png)

## Step 2: Deploy a Krossboard instance
From GCP Console

* Go to the Krossboard page on GCP Marketplace.
* Click **Launch on Compute Engine**. If you're prompted, select the project in which to create the instance.
* On the **New Krossboard VM deployment** page, first enter a **Deployment name**. This will be the root of your virtual machine name. Compute Engine appends **-vm** to this name when naming your instance.
* Choose a **Zone** and **Machine type**. You can leave the other settings as they are or change them as needed.
* Under the section **Identity and API access > Firewall**, select **Allow HTTP traffic** to enable access to Krossboard UI.
* Scroll to the bottom of the page, read the GCP Marketplace Terms of Service, and if you accept the terms, select the checkbox.
* Expand the section **Management, security, disks, networking, sole tenancy**, 
* Click **Deploy** to validate the deployment.
* Once the deployment completed, note the IP address of the instance.

## Step 3: Configure GCP IAM permissions to access GKE clusters
This step consists in creating a GCP service account with the predefined role of **Kubernetes Engine Viewer** (read-only access to GKE resources), and assign it to the krossboard instance.

First create the GCP service account with the aforementioned role.

* Go to the menu ![](/images/docs/gcp-menu.png), then select **IAM & Admin -> Service accounts**.
* Click **Create Service Account** and in the **Service account name** field, enter a name for the service account. 
* (Optional) Enter a description of the service account.
* Click **Create**.
* Click **Select a role** field and in the filter field, type **Kubernetes Viewer**.
* In the list of suggestions, select **Kubernetes Engine Viewer**.
* Click **Continue** and then on **Done** to complete the creation.


Then assign the service account to the Krossboard instance.

* Go to the menu ![](/images/docs/gcp-menu.png), then select **Compute Engine -> VM Instances**.
* Select the Krossboard instance from the list of virtual machines by clicking on its name.
* Click **Edit**.
* Scroll down to the **Service account** section and click on the field.
* Go through the displayed list of service accounts and select the one created above.
* Click **Save** to apply the change.
  
The Krossboard instance is now ready for operations.

## Step 4: Get Access to Krossboard UI
Open a browser tab and point it to this URL: **http://krossboard-IP-addr/**, while replacing **krossboard-IP-addr** with the address of the Krossboard instance.

**Note:** You may need to wait a while (typically an hour) to have all charts available. This is because [by design]({{< relref "/docs/overview-concepts-features" >}}), Krossboard is thought to provide consitent analytics with an hourly granularity.

The user interface features the following core analytics and reports:
 * **Current Usage**: For each cluster discovered and handled by Krossboard, this page displays piecharts showing the latest consolidated CPU and memory usage. Those reports -- updated every 5 minutes, highlight shares of resources, used, available and non-allocatable.
 * **Usage Trends & Accounting**: For each cluster -- selected on-demand by the user, this page provides various reports showing, hourly, daily and monthly usage analytics for CPU and memory resources. For each type of report (i.e. hourly, daily, monthly), the user can export the raw analytics data in CSV format for custom processing and visualization.
 * **Consolidated Usage & History**: This page provides a comprehensive usage reports covering all clusters for a user-defined period of time. The intend of those reports is to provide an at-a-glance visualization to compare the usage of different clusters for any period of time, which always the ability to export the raw analytics data in CSV for custom processing and visualization.

## Next Steps

* Checkout other [documentation resources]({{< relref "/docs" >}}).