+++
title = "Setup Krossboard for Amazon EKS"
description = ""
weight = 1
draft = false
bref = ""
toc = true 
+++

Krossboard is designed to work as a standalone EC2 virtual machine on AWS cloud.
As of current version, it discovers and handles EKS clusters on a per [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) basis. 

This guide describes steps to setup an instance of Krossboard within an AWS region. 

## Before you begin
To run this procedure successfully, it's assumed that:

 * You have a basic level of practice with AWS concepts.
 * You have access to an AWS account with sufficient permissions, to create and assign AWS IAM roles, and to create EC2 instances from AWS Marketplace.
 * You have access to AWS Management Console, though you can later adapt the steps for a scripted/automated deployment.
 * You have `kubectl` with admin access to your EKS clusters; this level of access is notably required to configure RBAC settings that Krossboard needs to retrieve metrics from Kubernetes.

## Summary of Steps
The installation steps would be straightforward and can be summarized as follows:

* Step 1: Create an AWS IAM role with the following actions `eks:ListClusters` and `eks:DescribeCluster`, i.e. a role that allow to discover EKS clusters. 
* Step 2: Deploy an EC2 instance of Krossboard from [AWS Marketplace](https://aws.amazon.com/marketplace). During this step, we should pay attention to:
  * Select the region in which the instance will be deployed
  * Assign the aforecreated AWS IAM role to the instance.
* Step 3: On EKS cluster, deploy an instance of [Kubernetes Metric Server](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html), which exposes metrics that Krossboard consumes to produce its advanced analytics.
* Step 4: On EKS cluster, update Kubernetes RBAC settings to allow Krossboard to query data from Kubernetes API. 
* Step 5: Get access to Krossboard UI

## Step 1: Create an AWS IAM role for Kroassboard
Log into the AWS Management Console:

* Select IAM service
* Go to `Roles` section
* Click on `Create role`
* Select `EC2` for type of trusted entity and click `Next`
* Click on `Create policy`, this will open a new tab to create a policy.
* In the policy tab, click on `JSON` section and then copy and paste the policy provided below.
* Click on `Review policy`
* Set a name and possibly a description for the policy.
* Click on `Create policy` to apply the changes.
* Go back to the first tab (role creation) and click on the refresh icon at the right corner of the policy list.
* Search for the created policy and select it.
* Click on `Next:Tabs` and fill in tags if applicable.
* Click on `Next:Review` and check that all the information provided are fine.
* Set a name and possibly a description for the role.
* Click on `Create role` to apply the changes and complete the role creation.
* **Copy the ARN of the role created**, it'll be needed later in this guide.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:ListClusters",
                "eks:DescribeCluster"
            ],
            "Resource": "*"
        }
    ]
}
```


## Step 2: Deploy Krossboard from AWS Marketplace
TODOD

## Step 3: Install Kubernetes Metrics Server on EKS
This step is based on the [official documentation of EKS](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html). Please refer to this link if you experienced any troubles.

It's required to first install [jq](https://stedolan.github.io/jq/):

```
sudo snap install jq --classic`
```

Once jq installed, run the following commands to download and deploy an instance of Kubernetes Metric Server in `kube-system` namespace.

```
DOWNLOAD_URL=$(curl -Ls "https://api.github.com/repos/kubernetes-sigs/metrics-server/releases/latest" | jq -r .tarball_url)
DOWNLOAD_VERSION=$(grep -o '[^/v]*$' <<< $DOWNLOAD_URL)
curl -Ls $DOWNLOAD_URL -o metrics-server-$DOWNLOAD_VERSION.tar.gz
mkdir metrics-server-$DOWNLOAD_VERSION
tar -xzf metrics-server-$DOWNLOAD_VERSION.tar.gz --directory metrics-server-$DOWNLOAD_VERSION --strip-components 1
kubectl apply -f metrics-server-$DOWNLOAD_VERSION/deploy/1.8+/
```

Verify that installation has been successfull.

```
kubectl -nkube-system get deploy metrics-serve
```
## Step 4: Update Kubernetes RBAC settings


### EKS-specific RBAC settings
We need to edit the `aws-auth` ConfigMap of EKS cluster to enable access to the cluster by the AWS IAM role assigned to the Krossboard instance.

First backup the current `aws-auth` ConfigMap.

```
kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-backup-$(date +%F).yaml
```

Then edit the ConfigMap to update cluster authorization settings.

```
kubectl -n kube-system edit configmap aws-auth
```

Add the following under the `mapRoles` section, while **replacing** `{{AccountID}}` with the id of your AWS account.
```
    - groups:
      - krossboard-data-processor
      rolearn: arn:aws:iam::{{AccountID}}:role/krossboard-data-processor
      username: arn:aws:iam::{{AccountID}}:role/krossboard-data-processor
```

### ClusterRole and Binding to retrieve metrics from Kubernetes API 
At this stage, we're almost done; Krossboard is able to discover EKS clusters, but is not yet allowed to retrieve metrics from Kubernetes -- this is due to default RBAC settings on EKS. 

The next command allows to create a Kubernetes `ClusterRole` and an associated `ClusterRoleBinding` to permit Krossboard to retrieve metrics from Kubernetes (read-only access). You can download the parameter file to review it.

```
kubectl apply -f https://krossboard.app/assets/k8s/clusterrolebinding-eks.yml
```


## Step 5: Get Access to Krossboard UI
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