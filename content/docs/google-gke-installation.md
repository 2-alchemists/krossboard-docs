+++
title = "Setup Krossboard for Google GKE"
description = ""
weight = 30
draft = false
bref = ""
toc = true 
+++

On Google Compute Platform (GCP), Krossboard works as a standalone compute virtual machine.
As of current version each Krossboard instance discovers and handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. 

This guide describes step-by-step how to setup an instance of Krossboard for a GCP project. 

## Before you begin
To run this procedure successfully, it's assumed that:
 * You have a basic level of practice with GCP concepts.
 * You have access to a GCP project with sufficient permissions, to create GCP IAM service account and to assign GCP predefined roles to a service account.
 * You have access to GCP Cloud Console, though you can later adapt the steps for a scripted/automated deployment.

> **Important:** Don't be confused, it's worth nothing that [GCP service accounts](https://cloud.google.com/iam/docs/understanding-service-accounts) and [Kubernetes services accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/) are two different concepts.

## Summary of Steps
The installation steps are straightforward and can be summarized as follows:

* Step 1: Select a GCP project for which Krossboard will be deployed.
* Step 2: Create a GCP service account and assign it to the Krossboard instance. This service account actually needs to have the predefined role of `Kubernetes Engine Viewer` (i.e. read-only access to GKE resources). 
* Step 3: Deploy an instance of Krossboard from the [GCP Marketplace](https://cloud.google.com/marketplace). During this step, you will assign the aforementioned GCP service account to the Krossboard instance being created.
* Step 4: Get access to Krossboard UI

## Step 1: Select a GCP project
 From GCP Cloud Console, select (or create if not yet the case) a project.

 ![](/images/docs/gcp-select-project.png)

 ## Step 2: Create a GCP service account
 Follow the next steps to create a GCP service account.
 
* In the top-left corner of the GCP console, click Menu ![](/images/docs/gcp-menu.png).
* Click `IAM & Admin` and then `Service accounts`.
* Click `Create Service Account` and in the `Service account name` field, enter a name for the service account. 
* (Optional) Enter a description of the service account.
* Click `Create`.
* Click the `Select a role` field and type `Kubernetes Viewer` in the filter field.
* In the list of suggestions and select `Kubernetes Engine Viewer`.
* Click `Continue` and then on `Done` to complete the creation.


## Step 3: Deploy Krossboard from the GCP Marketplace
Proceed as decribed below:

* Go to the Krossboard page on GCP Marketplace.
* Click on `Launch on Compute Engine`. If you're prompted, select the project in which to create the instance.
* On the `New Krossboard VM deployment` page, first enter a `Deployment name`. This will be the root of your virtual machine name. Compute Engine appends `-vm` to this name when naming your instance.
* Choose a `Zone` and `Machine type`. You can leave the other settings as they are or change them as needed.
* Under the section `Identity and API access > Service account`, select the service account created previously and select it.  
* Under the section `Identity and API access > Firewall`, select `Allow HTTP traffic` to enable access to Krossboard UI.
* Scroll to the bottom of the page, read the GCP Marketplace Terms of Service, and if you accept the terms, select the checkbox.
* Expand the section `Management, security, disks, networking, sole tenancy`, 
* Click `Deploy` to validate the deployment.
* Once the deployment completed, note the IP address of the instance.

## Step 4: Get Access to Krossboard UI
Open a browser tab and point it to this URL: `http://krossboard-IP-addr/`.

Replace `krossboard-IP-addr` with the address of the Krossboard instance.

**Note:** You may need to wait a while (typically an hour) to have all charts available. This is because [by design]({{< relref "/docs/overview-concepts-features" >}}), Krossboard is thought to provide consitent analytics with an hourly granularity.

The user interface features the following core analytics and reports:
 * **Current Usage**: For each cluster discovered and handled by Krossboard, this page displays piecharts showing the latest consolidated CPU and memory usage. Those reports -- updated every 5 minutes, highlight shares of resources, used, available and non-allocatable.
 * **Usage Trends & Accounting**: For each cluster -- selected on-demand by the user, this page provides various reports showing, hourly, daily and monthly usage analytics for CPU and memory resources. For each type of report (i.e. hourly, daily, monthly), the user can export the raw analytics data in CSV format for custom processing and visualization.
 * **Consolidated Usage & History**: This page provides a comprehensive usage reports covering all clusters for a user-defined period of time. The intend of those reports is to provide an at-a-glance visualization to compare the usage of different clusters for any period of time, which always the ability to export the raw analytics data in CSV for custom processing and visualization.

## Next Steps

* Checkout other [documentation resources]({{< relref "/docs" >}}).