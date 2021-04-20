+++
title = "Setup for Amazon EKS Clusters"
description = ""
weight = 50
draft = false
bref = ""
toc = true
aliases = ["/docs/deploy-for-amazon-eks/"]
+++


On Amazon AWS, Krossboard is available as ready-to-use virtual machine images. This release approach makes its deployment as simple than creating an EC2 virtual machine.

Once deployed, the Krossboard instance is able to automatically discover and handle your EKS clusters. By default, the discovery works on a per [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) basis, meaning that the instance does automatically discover and handle all your EKS clusters belonging to the region in which it's deployed.

This guide shows how to setup Krossboard for a given AWS region. It'll take you a couple of minutes to make it up and running.

## Before you begin
This installation guide assumes that:

* You have a basic level of practice with AWS concepts.
* You have an active AWS account with administrator access to create and configure your Krossboard instance. **Krossboard itself needs _read-only access_ to your EKS clusters**.
* You have access to a `bash >=4` terminal.
* You have [`kubectl`](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/), `curl` and [`jq`](https://stedolan.github.io/jq/) installed and accessible from your terminal.

## Deploy a Krossboard instance
The commands below shall deploy an instance of Krossboard in a couple of minutes.

Beforehand review the following parameters and adapt them if applicable.
  * Set the variable `KB_AWS_REGION` with the region of your EKS clusters (default is `eu-central-1`). This must be a [region where Krossboard is currently available]({{< relref "/docs/03_releases_information" >}}).
  * Set the variable `KB_AWS_KEY_PAIR` with a valid key pair in EC2. If you want to create a new key pair, read [this documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html).
  * Set the variable `KB_AWS_INSTANCE_TYPE` with the instance type (default is `t2.small` -- what should be sufficient unless you have a big number of EKS clusters along with many namespaces in the target region).

```sh
export KB_AWS_KEY_PAIR='MyKeyPair'
export KB_AWS_REGION='eu-central-1'
export KB_AWS_INSTANCE_TYPE='t2.small'
curl -so krossboard_aws_install.sh \
    https://raw.githubusercontent.com/2-alchemists/krossboard/master/tooling/setup/krossboard_aws_install.sh && \
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
curl -so krossboard_aws_configure_new_clusters.sh https://raw.githubusercontent.com/2-alchemists/krossboard/master/tooling/setup/krossboard_aws_configure_new_clusters.sh
bash ./krossboard_aws_configure_new_clusters.sh $KB_ROLE_ARN
```
 
Replace `ARN_OF_KROSSBOARD_ROLE` with the ARN of the role bound to your instance of Krossboard, and `YOUR_TARGET_REGION` with your target AWS region.

## Get access to Krossboard UI
Open a browser tab and point it to the Krossboard URL displayed at the end of the installation script. 

> It may take a few seconds before the instance finishes its initialization, during this time you may experience a loading error in the browser.

Here are the default username and password to sign in:

* **Username:** `krossboard`
* **Password (default):** `Kr0sSB8qrdAdm`

> It's highly recommended to change this default password as soon as possible. 
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Troubleshooting
In case of problem, first checkout the [Troubleshooting Page]({{< relref "/docs/901_troubleshooting" >}}) for an initial investigation.

If the problem you're experiencing is not listed there, open a ticket on the [Krossboard GitHub Page](https://github.com/2-alchemists/krossboard/issues).

Alternatively, if you do have an active support contract, you can also send an email directly to our customer support service: `support at krossboard.app`.

## Other Resources
* [Discover and explore Krossboard analytics and data export]({{< relref "02_analytics-and-data-export" >}})
* [Setup Krossboard for Google GKE]({{< relref "20_deploy-for-google-gke" >}})
* [Setup Krossboard for Azure AKS]({{< relref "30_deploy-for-azure-aks" >}})
* [Setup Krossboard for Cross-Cloud or On-premises Kubernetes]({{< relref "60_deploy-for-cross-cloud-and-on-premises-kubernetes" >}})