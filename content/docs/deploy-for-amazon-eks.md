+++
title = "Setup Krossboard for Amazon EKS clusters"
description = ""
weight = 50
draft = false
bref = ""
toc = true 
+++

On Amazon AWS, Krossboard works as a standalone EC2 virtual machine. 
Each instance discovers and handles EKS clusters on a per [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) basis. This means that, once installed and properly configured in a region, it can automatically discover and handle all your EKS clusters in that region. 

This guide describes step-by-step how to deploy and configure Krossboard for an AWS region in a couple of minutes.

## Before you begin
First note that Krossboard is published as ready-to-use public AWS images. This release approach aims to make its deployment as simple than creating an AWS virtual machine.

This installation guide assumes that:

* You have a basic level of practice with AWS concepts.
* You have an active AWS account with administrator access to create and configure your Krossboard instance. Krossboard itself requires only read-only access to your EKS clusters.
* You have [`kubectl`](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/), `curl` and [`jq`](https://stedolan.github.io/jq/) installed and accessible from your terminal.

> All the next steps are achieved from a terminal.

## Deploy a Krossboard instance
The following commands shall create and configure an instance of Krossboard.

Beforehand review the following parameters and adapt them if applicable.
  * Set the variable `KB_AWS_REGION` with the region of your EKS clusters (default is `eu-central-1`). This must be a [region where Krossboard is currently available]({{< relref "/docs/releases" >}}).
  * Set the variable `KB_AWS_KEY_PAIR` with a valid key pair in EC2. If you want to create a new key pair, read [this documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html).
  * Set the variable `KB_AWS_INSTANCE_TYPE` with the instance type (default is `t2.small` -- what should be sufficient unless you have a big number of EKS clusters along with many namespaces in the target region).

```sh
export KB_AWS_AMI='ami-0aea8e4fa412757fa'
export KB_AWS_KEY_PAIR='MyKeyPair'
export KB_AWS_REGION='eu-central-1'
export KB_AWS_INSTANCE_TYPE='t2.small'
curl -so krossboard_aws_install.sh \
    https://krossboard.app/artifacts/setup/krossboard_aws_install.sh && \
    bash ./krossboard_aws_install.sh
```

On success a summary of the installation shall be displayed as below:
```
=== Summary the Krossboard instance ===
Instance Name => krossboard-2020-08-27-1598480511
Instance ID => i-02ba079c0decfcff9
Region => eu-central-1
Key Pair => krossboard-test
Krossboard UI => http://1.2.3.4/
```

### Handle New EKS clusters
 During the installation, the Krossboard deployment script discovers and takes over existing EKS clusters (in the same region). After the installation, you need apply the following change to enable RBAC access (read-only) to each new EKS cluster. 
```sh
KB_ROLE_ARN='ARN_OF_KROSSBOARD_ROLE'
KB_AWS_REGION='YOUR_TARGET_REGION'
curl -so krossboard_aws_configure_new_clusters.sh https://krossboard.app/artifacts/setup/krossboard_aws_configure_new_clusters.sh
bash ./krossboard_aws_configure_new_clusters.sh $KB_ROLE_ARN
```
 
Replace `ARN_OF_KROSSBOARD_ROLE` with the ARN of the role bound to your instance of Krossboard, and `YOUR_TARGET_REGION` with your target AWS region.

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL displayed at the end of the installation script. **Note:** It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

The default username and password to sign in are:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. 
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* [Discover and explore Krossboard analytics and data export]({{< relref "/docs/analytics-reports-and-data-export" >}})
* [Setup Krossboard for Azure AKS]({{< relref "/docs/deploy-for-azure-aks" >}})
* [Setup Krossboard for Google GKE]({{< relref "deploy-for-google-gke" >}})