+++
title = "Setup Krossboard for AKS Clusters"
description = ""
weight = 2
draft = false
bref = ""
toc = true 
+++

Krossboard is designed to work as a standalone virtual machine on Azure cloud. 
As of current version, it discovers and handles handles AKS clusters on a per [Azure resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview) basis. 

The below steps describe how to setup an instance of Krossboard within a Azure resource group. It's assumed you're using Azure Portal, but you can adapt the procedure for a scripted/automated deployment.

To cover all the steps of this guide successfully, it's required that you have access to:
* An active Azure subscription.
* An admin access to that subscription


## Step 0: Summary of Steps
The installation steps are straightforward and can be summarized as follows:

* Step 1: Select or create the resource group where Krossboard will be deployed.
* Step 2: Deploy a Krossboard virtual machine from [Azure Marketplace](https://portal.azure.com/#blade/Microsoft_Azure_Marketplace).
* Step 3: Assign an managed identity to the created Krossboard virtual machine
* Step 4: Assign the Azure IAM roles `Managed Application Reader` and `Azure Kubernetes Service Cluster User Role` to the virtual machine. 
* Step 5: On each AKS cluster, update Kubernetes RBAC settings to allow Krossboard to query metrics from Kubernetes API. 
* Step 6: Get access to Krossboard UI
* Next Steps

## Step 1: Select or create the resource group
TODO

## Step 2: Deploy a Krossboard virtual machine
TODO

## Step 3: Assign a managed identity to the virtual machine
TODO

## Step 4: Assign required roles to the virtual machine
TODO

## Step 5: Update Kubernetes RBAC settings
Run this command to apply the Kubernetes `RoleBinding` required by Krossboard..

```
kubectl apply -f https://krossboard.app/assets/k8s/clusterrolebinding-eks.yml
```

## Step 6: Get Access to Krossboard UI
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