+++
title = "Setup Krossboard for GKE Clusters"
description = ""
weight = 3
draft = false
bref = ""
toc = true 
+++

Krossboard is designed to work as a standalone Compute Engine virtual machine on Google Compute Platform (GCP).
As of current version, it discovers and handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. 

The below steps describe how to setup an instance of Krossboard within a GCP project. It's assumed you're using GCP Cloud Console, but you can adapt the procedure for a scripted/automated deployment.

## Step 0: Summary of Steps
The installation steps are straightforward and can be summarized as follows:

* Step 1: Select a GCP project in which Krossboard will be deployed.
* Step 2: Create a GCP service account to assign to the Krossboard instance. This service account needs to have the predefined role of `roles/container.viewer` assigned to it. 
  In short, this role gives read-only access to GKE resources. 
* Step 3: Deploy an instance of Krossboard from [GCP Marketplace](https://cloud.google.com/marketplace)and, throughout the creation step, assign the created GCP service account to that instance.
* Step 4: Get access to Krossboard UI 
* Next Steps

> **Important:** it's worth nothing that [GCP service accounts](https://cloud.google.com/iam/docs/understanding-service-accounts) and [Kubernetes services accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/) are two different concepts.

## Step 1: Select a GCP project
 Krossboard handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. This means that, once it's deployed and configured for a GCP project, it discovers and takes over the usage analytics of any GKE clusters in that project.

 So before moving to next steps, you need to select (or create if not yet the case) a project from GCP console.

 ![](/images/docs/gcp-select-project.png)

 ## Step 2: Create a GCP service account
 Follow the next steps to create a GCP service account.
 

* In the top-left corner of the GCP console, click Menu ![](/images/docs/gcp-menu.png).
* Click `IAM & Admin` and then `Service accounts`.
* Click `Create Service Account` and in the `Service account name` field, enter a name for the service account. 
* (Optional) Enter a description of the service account.
* Click `Create`.
* Assign the prefedefined role of `roles/container.viewer` to the new account.


## Step 3: Deploy a Krossboard instance from GCP Marketplace
Proceed as follows to create an instance of Krossboard using Google Cloud Marketplace.


* Go to the Krossboard Marketplace page in the Google Cloud Console.

* Click `Launch on Compute Engine`. If you see a project selection window, choose the project in which to create the instance. If this is the first time you've launched Compute Engine, you must wait for the initial API configuration process to complete.
* On the `New Krossboard VM deployment` page, first enter a `Deployment name`. This will be the root of your virtual machine name. Compute Engine appends -vm to this name when naming your instance.
* Choose a `Zone` and `Machine type`. For this quickstart, you can leave all settings as they are or change them as needed.
* On the `Service account` field, search the service account created previously.  
* Enable HTTP(S) access to the instance
* Scroll to the bottom of the page, read the GCP Marketplace Terms of Service, and if you accept the terms, select the checkbox.
* Click `Deploy`.

## Step 4: Get Access to Krossboard UI
Open a browser and point it to the address `http://<krossboard-instance-addr>/`.

> You may need to wait a while (typically an hour) to have all the charts available. This is because by design, and with the intend to adhere to how modern clouds work, Krossboard is thought to provide consitent analytics on an hourly basis. [Learn more]({{< relref "/docs/how-data-are-collected-and-consolidated" >}}).

The user interface features the following core analytics and reports:
 * **Current Usage**: displays piecharts, for each cluster discovered by Krossboard in GKE, showing the latest consolidated CPU and memory usage. Those reports actually highlight every 5 minutes, the share of used, available and non-allocatable resources.
 * **Usage Trends & Accounting**: displays for each cluster selected by the user, its hourly, daily, and monthly usage analytics for CPU and memory resources. This page allows features the ability to export the data backed each displayed chart in CSV format.
 * **Consolidated Usage & History**: displays for all clusters, and specifically for CPU and memory resources, their consolidate usage over a user-defined period of time. This page also gives the ability to export data for the selected period of time in CSV format.

## Next Steps

* How does Krossboard consolidate Kubernetes metrics
* Which data Krossboard used to create report charts
* Export data in CSV format to create custom analytics