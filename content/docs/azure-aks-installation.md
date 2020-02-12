+++
title = "Setup Krossboard for Azure AKS"
description = ""
weight = 2
draft = false
bref = ""
toc = true 
+++

Krossboard is designed to work as a standalone virtual machine on Azure cloud.
As of current version, it discovers and handles AKS clusters on a per [Azure resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview) basis. 

This guide describes steps to setup an instance of Krossboard within a Azure resource group. 


## Before you begin
To run this procedure successfully, it's assumed that:

 * You have a basic level of practice with Azure concepts.
 * You have access to an Azure subscription with sufficient permissions, to assigned managed identity, to assign managed roles, as well as to create virtual machines from Azure Marketplace.
 * You have access to Azure Portal, though you can later adapt the steps for a scripted/automated deployment.
 * You have `kubectl` with admin access to your EKS clusters; this level of access is notably required to configure RBAC settings that Krossboard needs to retrieve metrics from Kubernetes.

## Summary of Steps
The installation steps would be straightforward and can be summarized as follows:

* Step 1: Select or create the resource group where Krossboard will be deployed.
* Step 2: Deploy a Krossboard virtual machine from [Azure Marketplace](https://portal.azure.com/#blade/Microsoft_Azure_Marketplace).
* Step 3: Assign a managed identity to the created Krossboard virtual machine
* Step 4: Assign the Azure IAM roles `Managed Application Reader` and `Azure Kubernetes Service Cluster User Role` to the virtual machine. 
* Step 5: On your AKS cluster, update Kubernetes RBAC settings to allow Krossboard to query metrics from Kubernetes API. 
* Step 6: Get access to Krossboard UI

## Step 1: Select or create the resource group
TODO

## Step 2: Deploy a Krossboard virtual machine
TODO

## Step 3: Assign a managed identity to the virtual machine
TODO

## Step 4: Assign required roles to the virtual machine
TODO

## Step 5: Update Kubernetes RBAC settings
At this stage, we're almost done; Krossboard is able to discover AKS clusters, but is nt yet allowed to retrieve metrics from Kubernetes -- this due to default RBAC settings on AKS. 

The next command allows to create a Kubernetes `ClusterRole` and an associated `ClusterRoleBinding` to permit Krossboard to retrieve metrics from Kubernetes (read-only access). You can download the parameter file to review it. 

```
kubectl apply -f https://krossboard.app/assets/k8s/clusterrolebinding-eks.yml
```

## Step 6: Get Access to Krossboard UI
Open a browser and point it to the address `http://<krossboard-instance-addr>/`.

**Note:** You may need to wait a while (typically an hour) to have all the charts available. This is because by design, and with the intend to adhere to how modern clouds work, Krossboard is thought to provide consitent analytics with an hourly granularity. [Learn more]({{< relref "/docs/how-data-are-collected-and-consolidated" >}}).

The user interface features the following core analytics and reports:
 * **Current Usage**: displays piecharts, for each cluster discovered by Krossboard in GKE, showing the latest consolidated CPU and memory usage. Those reports actually highlight every 5 minutes, the share of used, available and non-allocatable resources.
 * **Usage Trends & Accounting**: displays for each cluster selected by the user, its hourly, daily, and monthly usage analytics for CPU and memory resources. This page allows features the ability to export the data backed each displayed chart in CSV format.
 * **Consolidated Usage & History**: displays for all clusters, and specifically for CPU and memory resources, their consolidate usage over a user-defined period of time. This page also gives the ability to export data for the selected period of time in CSV format.

## Next Steps

* How does Krossboard consolidate Kubernetes metrics
* Which data Krossboard used to create report charts
* Export data in CSV format to create custom analytics