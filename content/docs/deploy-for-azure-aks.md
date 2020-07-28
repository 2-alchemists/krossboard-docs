+++
title = "Setup Krossboard for Azure AKS"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

On Microsoft Azure, Krossboard works as a standalone virtual machine.

> Each instance of Krossboard automatically discovers and handles AKS clusters according to permissions assigned to it through Azure IAM roles. In order words, given an appropriate permission level, an instance of Krossboard can even discover and handle all the AKS clusters within a subscription.

This guide describes step-by-step how to deploy and configure a Krossboard instance. 


## Before you begin
This guide should be straightforward to follow, assuming that:

* You have a basic level of practice with Azure concepts.
* You have access to an Azure subscription with sufficient permissions to:
  * Assign managed identity;
  * Assign managed roles;
  * Use Azure portal, though the steps can be adapted for a scripted/automated deployment.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed with admin-level access to your AKS clusters.

## Step 1: Deploy a Krossboard instance
From the Azure portal:

* Type **virtual machines** in the search.
* Under **Services**, select **Virtual machines**.
* In the **Virtual machines** page, select **Add**.
* In the **Basics** tab, under **Project details**, select a target subscription.
* For **Resource group**, search and select the resource group where the Krossboard instance will be deployed.
  > It's worth to recall that this does not limit the scope of AKS clusters that Krossboard can handle automatically. Only the role(s) assigned to the instance limit(s) its scope within a subscription. See later in this page for required roles.
* Name the virtual machine and select a region.
* For **Image**, click **Browse all public and private images**.
* In the search field, type **krossboard**, and select the latest stable version of Krossboard.
* For instance **Size**, if you do have a maximum of 3 clusters, a `Standard B1ms` instance would be sufficient.
  Otherwise we do recommend to start with a `Standard B2s` instance.
* Set information for the **Administrator account** (SSH username and public key).
  > According to your organization policies, make sure to enable SSH and set a valid **public key** to be able to access the instance for maintenance.
* For **Inbound port rules** section, check **Allow selected ports**.
* Click the **Select inbound ports** field to enable **HTTP** and **SSH** (optional) traffic.
* You can leave the other settings as is, click **Review + Create**.
* Review the settings and click **Create** to start the instance. 

## Step 2: Configure Azure IAM permissions to discover AKS clusters
A standard setup of Krossboard requires the role of **Managed Application Reader** and the role of **Azure Kubernetes Service Cluster User Role**. 

### Step 2.1: Enable instance's managed identity

* Connect to Azure portal as a subscription administrator.
* Select **Home -> Virtual machines** to list virtual machine instances.
* Click on the Krossboard instance in the list of virtual machines to display the instance's properties window.
* Select **Identity** from the left pane of the properties window.
* Under **System assigned** tab, switch **Status** to **On**.
* Click **Save** and, when prompted, click **Yes** to confirm the change. 

### Step 2.2: Assign IAM roles

* Connect to Azure portal as a subscription administrator.
* Select **Home -> Subscriptions** and, in the list of subscriptions, select the target subscription.
* Select **Access control (IAM)** .
* From the top of the right pane, select **Add -> Add role assignment`; this will open a role assignment pane.
* In the field **Role**, select the role **Azure Kubernetes Service Cluster User Role**.
* In the field **Select**, search for the Krossboard instance created in step 2 above and select it.
* Click **Save** to validate the assignement.
* Again in the field **Role**, select the role **Managed Applications Reader**.
* In the field **Select**, search for the Krossboard instance created in step 2 above and select it.
* Click **Save** to validate the assignement.

## Step 3: Configure Kubernetes RBAC to access cluster's metrics
At this stage we're almost done, but Krossboard is not yet allowed to retrieve metrics from discovered AKS clusters. The last step is to configure RBAC settings on each AKS cluster to enable the required permissions.

To ease that, Krossboard is released with a ready-to-use configuration file that can be applied as follows on your AKS clusters as below. This create a **ClusterRole** and an associated **ClusterRoleBinding** giving access to the target AKS cluster metrics.


```
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-aks.yml
```

## Step 5: Get Access to Krossboard UI
Open a browser tab and point it to this URL `http://instance-addr/` while replacing **instance-addr** with the IP address of the Krossboard instance.

Here are credentials to log in:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. To do so, log into the instance through SSH and run this command:
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).