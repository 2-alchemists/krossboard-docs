+++
title = "Setup Krossboard for Amazon EKS"
description = ""
weight = 10
draft = false
bref = ""
toc = true 
+++

On Amazon Web Services (AWS), Krossboard works as a standalone EC2 virtual machine.
As of current version each instance of Krossboard automatically discovers and handles EKS clusters on a per [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) basis. 

This guide describes step-by-step how to setup an instance of Krossboard for an AWS region. 

## Before you begin
This guide should be straightforward to follow, assuming that:

* You have a basic level of practice with AWS concepts.
* You have access to an AWS account with sufficient permissions, to create and assign AWS IAM roles, and to create EC2 instances from AWS Marketplace.
* You have access to AWS Management Console, though you can later adapt the steps for a scripted/automated deployment.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed with admin-level access to your EKS clusters; this level of access is required to configure RBAC settings that Krossboard needs.

## Step 1: Deploy Krossboard from the AWS Marketplace
Proceed as decribed below to create an instance of Krossboard from Azure Marketplace:

* TODO
* Ensure that the instance's security groups enable access on the VM on port 80 and 443, i.e. to provide access to Krossboard UI.
* Once the deployment completed, note the IP address of the instance.


## Step 2: Configure AWS IAM permissions to discover EKS clusters
A standard setup of Krossboard requires to assume an AWS IAM role with the action of `eks:ListClusters` and the action of `eks:DescribeCluster` associated to it.

Follow this procedure to create such a role with the required actions: 

* Go to AWS Management Console.
* Select the `IAM` service.
* Go to `Roles` section.
* Click on `Create role`.
* Select `EC2` for type of trusted entity and click `Next:Permissions`.
* Click on `Create policy`, this will open a new tab to create a policy.
* In the policy tab, click on `JSON` section and then copy and paste the policy provided below.
  **Important:** Replace the existing policy content.
* Click on `Review policy`.
* Set a name and possibly a description for the policy.
* Click on `Create policy` to apply the changes.
* Go back to the initial role creation tab, and click on the refresh icon at the right corner of the policy list.
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

The next procedure associates the role to the Krossboard instance.

* Go to AWS Management Console.
* Select the `EC2` service.
* Go to the `Instances` section and then select `instances`.
* Navigate through the displayed list of instances to select the Krossboard instance.
* Go to the menu `Actions -> Instance Settings -> Attach/Replace IAM Role`.
* In the `IAM role` field, select the role created above.
* Click on `Apply` to save the change.

## Step 3: Install Kubernetes Metrics Server on each EKS cluster
This step is based on the [official documentation of EKS](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html). Please refer to this link if you experienced any troubles.

It's required to first install [jq](https://stedolan.github.io/jq/):

```
sudo snap install jq --classic
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
kubectl -nkube-system get deploy metrics-server
```
## Step 4: Configure RBAC to access EKS cluster's metrics
First we need to edit the `aws-auth` ConfigMap of the EKS cluster to enable access to the cluster by the AWS IAM role assigned to the Krossboard instance.

Before any changes, we recommend to backup the current `aws-auth` ConfigMap.

```
kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-backup-$(date +%F).yaml
```

Once the backup done, edit the ConfigMap.

```
kubectl -n kube-system edit configmap aws-auth
```

Add the following lines under the `mapRoles` section, while **replacing** each instance of the snippet `<ARN of Krossboard Role>` with the ARN of the role created previously.
```
    - groups:
      - krossboard-data-processor
      rolearn: <ARN of Krossboard Role>
      username: <ARN of Krossboard Role>
```

At this stage we're almost done, but Krossboard is not yet allowed to retrieve metrics from discovered EKS clusters. The last step is to configure RBAC settings on each EKS cluster to enable the required permissions.

To ease that, Krossboard is released with a ready-to-use configuration file that can be applied as follows on your EKS clusters as below. This create a `ClusterRole` and an associated `ClusterRoleBinding` giving access to the target EKS cluster metrics.

```
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-eks.yml
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