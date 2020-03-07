+++
title = "Setup Krossboard for Azure AKS"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure, Krossboard works as a standalone virtual machine.
As of current version each instance of Krossboard automatically discovers and handles AKS clusters on a per [Azure resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/overview) basis. 

This guide describes step-by-step how to setup an instance of Krossboard for an Azure resource group. 


## Before you begin
To run this procedure successfully, it's assumed that:

 * You have a basic level of practice with Azure concepts.
 * You have access to an Azure subscription with sufficient permissions to:
   * Assign managed identity;
   * Assign managed roles;
   * Create virtual machines from [the Azure Marketplace](https://portal.azure.com/#blade/Microsoft_Azure_Marketplace).
   * Use Azure Portal (though the steps can be later adapted for a scripted/automated deployment).
 * You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed with admin-level access to your AKS clusters; this level of access is required to configure RBAC settings that Krossboard needs.

## Summary of Steps
The installation steps would be straightforward and can be summarized as follows:

* Step 1: Select or create the resource group where Krossboard will be deployed.
* Step 2: Deploy a Krossboard virtual machine from the Azure Marketplace.
* Step 3: Configure Azure IAM permissions to discover AKS clusters
* Step 4: Configure each AKS cluster's RBAC settings to enable access (read-only) to metrics. 
* Step 5: Get access to Krossboard UI

## Step 1: Select or create the resource group
Krossboard discovers and handles AKS clusters as a per resource group basics. Those clusters can be spread accross different regions and zones in that resource group. 

So let's consider that we've selected a resource group and move forward.

## Step 2: Deploy Krossboard from the Azure Marketplace
Proceed as decribed below to create an instance of Krossboard from the Azure Marketplace:

* TODO
* Once the deployment completed, note the IP address of the instance.


## Step 3: Configure Azure IAM permissions to discover AKS clusters
A standard setup of Krossboard requires the role of `Managed Application Reader` and the role of `Azure Kubernetes Service Cluster User Role`. 

As a prerequisite, the instance must enable an Azure managed identity. 

* Connect to Azure portal as a subscription administrator.
* Select `Home -> Virtual machines` to list virtual machine instances.
* Click on the Krossboard instance in the list of virtual machines to display the instance's properties window.
* Select `Identity` from the left pane of the properties window.
* Under `System assigned` tab, switch `Status` to `On`.
* Click on `Save` and, when prompted, click on `Yes` to confirm the change. 

Once the instance has its managed identity enabled, we can assign the required Azure IAM roles . 

* Connect to Azure portal as a subscription administrator.
* Select `Home -> Subscriptions` and, in the list of subscriptions, select the target subscription.
* Select `Access control (IAM)` .
* From the top of the right pane, select `Add -> Add role assignment`; this will open a role assignment pane.
* In the field `Role`, select the role `Azure Kubernetes Service Cluster User Role`.
* In the field `Select`, search for the Krossboard instance created in step 2 above and select it.
* Click on `Save` to validate the assignement.
* Again in the field `Role`, select the role `Managed Applications Reader`.
* In the field `Select`, search for the Krossboard instance created in step 2 above and select it.
* Click on `Save` to validate the assignement.

## Step 4: Configure RBAC to access AKS cluster's metrics
At this stage we're almost done, but Krossboard is not yet allowed to retrieve metrics from discovered AKS clusters. The last step is to configure RBAC settings on each AKS cluster to enable the required permissions.

To ease that, Krossboard is released with a ready-to-use configuration file that can be applied as follows on your AKS clusters as below. This create a `ClusterRole` and an associated `ClusterRoleBinding` giving access to the target AKS cluster metrics.


```
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
```

## Step 5: Get Access to Krossboard UI
Open a browser tab and point it to this URL: `http://krossboard-IP-addr/`.

Replace `krossboard-IP-addr` with the address of the Krossboard instance.

**Note:** You may need to wait a while (typically an hour) to have all charts available. This is because [by design]({{< relref "/docs/overview-concepts-features" >}}), Krossboard is thought to provide consitent analytics with an hourly granularity.

The user interface features the following core analytics and reports:
 * **Current Usage**: For each cluster discovered and handled by Krossboard, this page displays piecharts showing the latest consolidated CPU and memory usage. Those reports -- updated every 5 minutes, highlight shares of resources, used, available and non-allocatable.
 * **Usage Trends & Accounting**: For each cluster -- selected on-demand by the user, this page provides various reports showing, hourly, daily and monthly usage analytics for CPU and memory resources. For each type of report (i.e. hourly, daily, monthly), the user can export the raw analytics data in CSV format for custom processing and visualization.
 * **Consolidated Usage & History**: This page provides a comprehensive usage reports covering all clusters for a user-defined period of time. The intend of those reports is to provide an at-a-glance visualization to compare the usage of different clusters for any period of time, which always the ability to export the raw analytics data in CSV for custom processing and visualization.

## Next Steps

* Checkout other [documentation resources]({{< relref "/docs" >}}).