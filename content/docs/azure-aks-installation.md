+++
title = "Setup Krossboard for Azure AKS"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure cloud, Krossboard is designed to work as a standalone virtual machine within a [Azure resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview).
In that resource group, it can discover and take over any AKS clusters. 

This guide describes steps to setup an instance of Krossboard within an Azure resource group. 


## Before you begin
To run this procedure successfully, it's assumed that:

 * You have a basic level of practice with Azure concepts.
 * You have access to an Azure subscription with sufficient permissions to:
   * Assign managed identity;
   * Assign managed roles;
   * Create virtual machines from Azure Marketplace.
 * You have access to Azure Portal, though the steps can be easily adapted for a scripted/automated deployment.
 * You're using a Linux-based station with [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed.
 * You have admin-level access to your AKS clusters through `kubectl`; this level of access is notably required to configure RBAC settings that Krossboard needs to retrieve metrics from Kubernetes.

## Summary of Steps
The installation steps would be straightforward and can be summarized as follows:

* Step 1: Select or create the resource group where Krossboard will be deployed.
* Step 2: Deploy a Krossboard virtual machine from [Azure Marketplace](https://portal.azure.com/#blade/Microsoft_Azure_Marketplace).
* Step 3: Assign a managed identity to the created Krossboard virtual machine
* Step 4: Assign the Azure IAM roles `Managed Application Reader` and `Azure Kubernetes Service Cluster User Role` to the Krossboard virtual machine. 
* Step 5: On each AKS cluster, update RBAC settings to allow Krossboard to query metrics from Kubernetes. 
* Step 6: Get access to Krossboard UI

## Step 1: Select or create the resource group
Krossboard discovers and handles AKS clusters as a per resource group basics. The clusters can be spread accross different regions/zones in the resource group. 
In contrary, for clusters located in different resource groups, you'll need an instance of Krossboard per resource group. 

So let's consider that we've selected a resource group and move forward.

## Step 2: Deploy Krossboard from the Azure Marketplace
Proceed as decribed below to create an instance of Krossboard from the Azure Marketplace:

* TODO
* Once the deployment completed, note the IP address of the instance.


## Step 3: Assign a managed identity to the virtual machine
The Krossboard instance needs to have an Azure managed identity. This is a prerequisite to assign Azure IAM roles to the instance. 

Connect to Azure portal as a subscription administrator and perform the below steps:

* Select `Home -> Virtual machines` to show the list of virtual machines.
* Select the Krossboard instance in the list of virtual machines; this will open the instance's properties window.
* Select `Identity` from the left pane of the properties window.
* Under `System assigned` tab, switch the `Status` to `On`.
* Click on `Save` and, when prompted, click on `Yes` to confirm the change. 


## Step 4: Assign required roles to the virtual machine
This step allows to set sufficient Azure IAM roles to the Krossboard instance. These roles give read-only permissions to discover AKS clusters. 

Connect to Azure portal as a subscription administrator and perform the below steps:

* Select `Home -> Subscriptions` and, in the list of subscriptions, select the target subscription.
* Select `Access control (IAM)` .
* From the top of the right pane, select `Add -> Add role assignment`; this will open a role assignment pane.
* In the field `Role`, select the role `Azure Kubernetes Service Cluster User Role`.
* In the field `Select`, search for the Krossboard instance created in step 2 above and select it.
* Click on `Save` to validate the assignement.
* Again in the field `Role`, select the role `Managed Applications Reader`.
* In the field `Select`, search for the Krossboard instance created in step 2 above and select it.
* Click on `Save` to validate the assignement.

## Step 5: Update Kubernetes RBAC settings
At this stage, we're almost done; Krossboard is able to discover AKS clusters, but is nt yet allowed to retrieve metrics from Kubernetes -- this due to default RBAC settings on AKS. 

The next command creates a `RoleBinding` and an associated `ClusterRoleBinding` to permit Krossboard to retrieve metrics from Kubernetes (read-only access). 


```
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
```

## Step 6: Get Access to Krossboard UI
Open a browser and point it to the address `http://<krossboard-IP-addr>/`.

**Note:** You may need to wait a while (typically an hour) to have all charts available. This is because [by design]({{< relref "/docs/overview-concepts-features" >}}), which is thought with the intend to adhere to the accounting paradigm of public clouds, Krossboard is thought to provide consitent analytics with an hourly granularity.

The user interface features the following core analytics and reports:
 * **Current Usage**: For each cluster discovered and handled by Krossboard, this page displays piecharts showing the latest consolidated CPU and memory usage. Those reports -- updated every 5 minutes, highlight shares of resources, used, available and non-allocatable.
 * **Usage Trends & Accounting**: For each cluster -- selected on-demand by the user, this page provides various reports showing, hourly, daily and monthly usage analytics for CPU and memory resources. For each type of report (i.e. hourly, daily, monthly), the user can export the raw analytics data in CSV format for custom processing and visualization.
 * **Consolidated Usage & History**: This page provides a comprehensive usage reports covering all clusters for a user-defined period of time. The intend of those reports is to provide an at-a-glance visualization to compare the usage of different clusters for any period of time, which always the ability to export the raw analytics data in CSV for custom processing and visualization.

## Next Steps

* Checkout other [documentation resources]({{< relref "/docs" >}}).