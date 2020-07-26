+++
title = "Setup Krossboard for Amazon EKS"
description = ""
weight = 10
draft = false
bref = ""
toc = true 
+++

On Amazon Web Services (AWS), Krossboard works as a standalone EC2 virtual machine.
Each instance of Krossboard automatically discovers and handles EKS clusters on a per [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) basis. 

This guide describes step-by-step how to deploy and configure an instance of Krossboard for an AWS region. 

## Before you begin
This guide should be straightforward to follow, assuming that:

* You have a basic level of practice with AWS concepts.
* You have access to an AWS account with sufficient permissions to:
  * Create and assign AWS IAM roles;
  * Create EC2 instances.
  * Use AWS Management Console, though the steps can be adapted for a scripted/automated deployment.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed with admin-level access to your EKS clusters.

> Note that all the below steps are achieved from the AWS Management Console.

## Step 1: Select an AWS region
As Krossboard discovers and handles EKS clusters as a per region basics, we shall first select a region.

![AWS refresh icon](/images/docs/aws-select-a-region.png)

## Step 2: Create an IAM role for Krossboard
A Krossboard instance needs to assume an AWS IAM role with the following actions enabled: **eks:ListClusters** and **eks:DescribeCluster**.

Here is the procedure to achieve that: 

* Go to AWS Management Console.
* In the field **Find Services**, find and select the **IAM** service.
* Click **Roles** at the left pane.
* Click **Create role**.
* Under the section **Common use cases**, click **EC2**.
* Click **Next:Permissions**.
* Click **Create policy**. This will bring you to a new tab to create a policy.
* Click on the **JSON** tab.
* **Copy and paste** the below policy. You must REPLACE the existing policy.
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
* Click **Review policy**.
* **Name the policy** and provide a description.
* Click **Create policy** to apply the changes.
* Go back to the **role creation tab**, and click the refresh button (![AWS refresh icon](/images/docs/aws-refresh-icon.png)).
* In the field **Filter policies**, find and select the policy just created.
* Click **Next:Tags** and fill in tags if applicable.
* Click **Next:Review** and check that all the information provided are correct.
* **Name the role** and provide a description if needed.
* Click **Create role** to complete the creation.
* **Note the ARN of the role**, it'll be needed later in this guide.


## Step 2: Deploy a Krossboard instance
From the AWS Management Console:

* In the field **Find Services**, find and select the **EC2** service.
* Click **Instances** at the left pane, then click **Launch Instance**.
* In the field **Search for AMI**, type **krossboard**, click the latest stable version of Krossboard and click **select**. 
* For **Instance Type**, if you do have a maximum of 3 clusters, a `t2.small` instance would be sufficient.
  Otherwise we do recommend to start with a `t2.medium` instance.
* Click **Next: Configure Instance Details**.
* For **IAM role**, select the role created previously.
* Click the **Configure Security Group** tab.
* Click **Add Rule** to enable HTTP access on port 80 from the target users' network.
* Click **Review and Launch** and verify the information provided.
* Click **Launch**, then make sure to set a **SSH Key Pair** to be able to access the instance for maintenance.
* Confirm the instance creation.

## Step 4: Install Kubernetes Metrics Server
> This step must be achieved on each cluster.

The following commands shall download and deploy the specified version of Kubernetes Metric Server in the namespace **kube-system**.

```
DOWNLOAD_VERSION=v0.3.6
DOWNLOAD_URL=https://api.github.com/repos/kubernetes-sigs/metrics-server/tarball/${DOWNLOAD_VERSION}
curl -Ls $DOWNLOAD_URL -o metrics-server-$DOWNLOAD_VERSION.tar.gz
mkdir metrics-server-$DOWNLOAD_VERSION
tar -xzf metrics-server-$DOWNLOAD_VERSION.tar.gz \
    --directory metrics-server-$DOWNLOAD_VERSION \
    --strip-components 1
kubectl apply -f metrics-server-$DOWNLOAD_VERSION/deploy/1.8+/
```

Verify that installation has been successful.

```
kubectl -nkube-system get deploy metrics-server
```
## Step 5: Configure RBAC to access EKS cluster's metrics
First we need to edit the **aws-auth** ConfigMap of the EKS cluster to enable access to the cluster by the AWS IAM role assigned to the Krossboard instance.

Before any changes, we do recommend to backup the current **aws-auth** ConfigMap.

```
kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-backup-$(date +%F).yaml
```

Once the backup done, edit the ConfigMap.

```
kubectl -n kube-system edit configmap aws-auth
```

Add the following lines under the **mapRoles** section, while **replacing** each instance of the snippet **<ARN of Krossboard Role>** with the ARN of the role created previously.
```
    - groups:
      - krossboard-data-processor
      rolearn: <ARN of Krossboard Role>
      username: <ARN of Krossboard Role>
```

At this stage we're almost done, but Krossboard is not yet allowed to retrieve metrics from discovered EKS clusters. The last step is to configure RBAC settings on each EKS cluster to enable the required permissions.

To ease that, Krossboard is released with a ready-to-use configuration file that can be applied as follows on your EKS clusters as below. This create a **ClusterRole** and an associated **ClusterRoleBinding** giving access to the target EKS cluster metrics.

```
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-eks.yml
```

## Step 6: Get Access to Krossboard UI
Open a browser tab and point it to this URL `http://instance-addr/` while replacing **instance-addr** with the IP address of the Krossboard instance.

Here are credentials to log in:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. To do so, log into the instance through SSH and run this command:
> ```
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).