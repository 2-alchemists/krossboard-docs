+++
title = "Setup Krossboard for EKS Clusters"
description = ""
weight = 1
draft = false
bref = ""
toc = true 
+++

Krossboard is designed to work as a standalone EC2 virtual machine on AWS cloud. 
As of current version, it discovers and handles handles EKS clusters on a per [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) basis. 

The below steps describe how to setup an instance of Krossboard within an AWS region. It's assumed you're using AWS Management Console, but you can adapt the procedure for a scripted/automated deployment.

## Step 0: Summary of Steps
The installation steps are straightforward and can be summarized as follows:

* Step 1: Select the AWS region in which Krossboard will be deployed.
* Step 2: On each EKS cluster, deploy an instance of [Kubernetes Metric Server](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html), which exposes metrics that Krossboard consumes to produce its advanced analytics.
* Step 3: On each EKS cluster, update Kubernetes RBAC settings to allow Krossboard to query data from Kubernetes API. 
* Step 4: Create an AWS IAM role with the following actions `eks:ListClusters` and `eks:DescribeCluster`, i.e. a role that allow to discover EKS clusters. 
* Step 5: Deploy an EC2 instance of Krossboard from [AWS Marketplace](https://aws.amazon.com/marketplace) and, throughout the creation step, assign the created AWS IAM role to that instance.
* Step 6: Get access to Krossboard UI
* Next Steps

## Step 1: Select an AWS region
Access AWS Management Console and select a region at the top right corner.

## Step 2: Install Kubernetes Metrics Server on EKS
The following steps is based on [EKS's official documentation](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html).

The next commands require that you first install [jq](https://stedolan.github.io/jq/):

```
sudo snap install jq --classic`
```

Then perform the following commands:

```
DOWNLOAD_URL=$(curl --silent "https://api.github.com/repos/kubernetes-incubator/metrics-server/releases/latest" | jq -r .tarball_url)
DOWNLOAD_VERSION=$(grep -o '[^/v]*$' <<< $DOWNLOAD_URL)
curl -Ls $DOWNLOAD_URL -o metrics-server-$DOWNLOAD_VERSION.tar.gz
mkdir metrics-server-$DOWNLOAD_VERSION
tar -xzf metrics-server-$DOWNLOAD_VERSION.tar.gz --directory metrics-server-$DOWNLOAD_VERSION --strip-components 1
kubectl apply -f metrics-server-$DOWNLOAD_VERSION/deploy/1.8+/
```

## Step 3: Update Kubernetes RBAC settings
First edit the `aws-auth` ConfigMap of your EKS cluster.

```
kubectl -n kube-system edit configmap aws-auth
```

Add the following entry under `mapRoles` section.
```
    - groups:
      - krossboard-data-processor
      rolearn: arn:aws:iam::{{AccountID}}:role/krossboard-data-processor
      username: arn:aws:iam::{{AccountID}}:role/krossboard-data-processor
```

> **WARNING:** Please replace `{{AccountID}}` with the id of your AWS account, and take care to not remove existing `mapRoles` entries.

Then run this command to apply the Kubernetes `RoleBinding` required by Krossboard.

```
kubectl apply -f https://krossboard.app/assets/k8s/clusterrolebinding-eks.yml
```

## Step 2: Create an AWS IAM role for Kroassboard
Log into the AWS Management Console:

* Select IAM service
* Go to `Role` section
* Create a role name `krossboard-data-processor`
* Create a policy and set it with below JSON content
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