+++
title = "Setup Krossboard for Azure AKS"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure cloud, Krossboard is designed to work as a standalone virtual machine.
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

## Step 2: Deploy a Krossboard VM from Azure Marketplace
Proceed as decribed below to create an instance of Krossboard from Azure Marketplace:

* TODO
* Once the deployment completed, note the IP address of the instance.


## Step 3: Assign a managed identity to the virtual machine
TODO

## Step 4: Assign required roles to the virtual machine
TODO

## Step 5: Update Kubernetes RBAC settings
At this stage, we're almost done; Krossboard is able to discover AKS clusters, but is nt yet allowed to retrieve metrics from Kubernetes -- this due to default RBAC settings on AKS. 

The next command allows to create a Kubernetes `ClusterRole` and an associated `ClusterRoleBinding` to permit Krossboard to retrieve metrics from Kubernetes (read-only access). You can download the parameter file to review it. 

```
kubectl apply -f https://krossboard.app/artifacts/k8s/clusterrolebinding-eks.yml
```

## Step 6: Get Access to Krossboard UI
Open a browser and point it to the address `http://<krossboard-IP-addr>/`.

**Note:** You may need to wait a while (typically an hour) to have all charts available. This is because [by design]({{< relref "/docs/how-data-are-collected-and-consolidated" >}}), which is thought with the intend to adhere to the accounting paradigm of public clouds, Krossboard is thought to provide consitent analytics with an hourly granularity.

The user interface features the following core analytics and reports:
 * **Current Usage**: For each cluster discovered and handled by Krossboard, this page displays piecharts showing the latest consolidated CPU and memory usage. Those reports -- updated every 5 minutes, highlight shares of resources, used, available and non-allocatable.
 * **Usage Trends & Accounting**: For each cluster -- selected on-demand by the user, this page provides various reports showing, hourly, daily and monthly usage analytics for CPU and memory resources. For each type of report (i.e. hourly, daily, monthly), the user can export the raw analytics data in CSV format for custom processing and visualization.
 * **Consolidated Usage & History**: This page provides a comprehensive usage reports covering all clusters for a user-defined period of time. The intend of those reports is to provide an at-a-glance visualization to compare the usage of different clusters for any period of time, which always the ability to export the raw analytics data in CSV for custom processing and visualization.

## Next Steps

* Checkout other [documentation resources]({{< relref "/docs" >}}).