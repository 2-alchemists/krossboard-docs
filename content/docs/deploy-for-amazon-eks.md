+++
title = "Setup Krossboard for Amazon EKS"
description = ""
weight = 50
draft = false
bref = ""
toc = true 
+++

On Amazon AWS, Krossboard works as a standalone EC2 virtual machine. 

Each instance works on a per [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) basis. This means that, once installed and properly configured in a region, it can automatically discover and handle all your EKS clusters in that region. 

To ease its deployment, Krossboard is published as public AWS images ready to use.

This guide describes step-by-step how to deploy and configure Krossboard for an AWS region. 

## Before you begin
This installation guide assumes that:

* You have a basic level of practice with AWS concepts.
* You can have access to AWS Management Console and to AWS CLI with sufficient permissions: (1) to create and assign AWS IAM roles; (2) to create EC2 instances; and (3) to access to EKS clusters in the selected region.
* You have [`kubectl`](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/), `curl` and [`jq`](https://stedolan.github.io/jq/) installed and accessible from your terminal.

> All the next steps are achieved from a terminal.

## Deploy a Krossboard instance
The following commands shall create and configure an instance of Krossboard.

Beforehand review the following parameters and adapt them if applicable.
  * Set the variable `KB_AWS_KEY_PAIR` with a valid key pair in EC2. If you want to create a new key pair, you can read [this documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html).
  * Set the variable `KB_AWS_AMI` with a valid Krossboard image (see the [list of available images]({{< relref "/docs/releases" >}})).
  * (Optional) Set the variable `KB_AWS_REGION` with the region where your EKS are (will be) located.  Krossboard will be deployed in the same region. If not set, `AWS_DEFAULT_REGION` (if set) will be used.
  * (Optional) Set the variable `KB_AWS_INSTANCE_TYPE` with the instance type. If not set `t2.small` will be used, which is a good starting point unless you have 10+ EKS clusters with many namespaces in the target region.

```sh
export KB_AWS_KEY_PAIR='MyKeyPair'
export KB_AWS_REGION='eu-central-1'
export KB_AWS_INSTANCE_TYPE='t2.small'
export KB_AWS_AMI='ami-0fa8675e6d205da2b'

curl -so krossboard_aws_install.sh \
  https://krossboard.app/artifacts/setup/krossboard_aws_install.sh && \
  bash ./krossboard_aws_install.sh
```

> **Note for new EKS clusters:** During the installation, the Krossboard deployment script discovers and takes over existing EKS clusters (in the same region). After the installation, you need apply the following change to enable RBAC access (read-only) to each new EKS cluster. Replace `<ARN_OF_KROSSBOARD_ROLE>` with the ARN of the role bound to your instance of Krossboard.
> ```sh
> KB_ROLE_ARN='<ARN_OF_KROSSBOARD_ROLE>'
> curl -so krossboard_aws_configure_new_clusters.sh https://krossboard.app/artifacts/setup/krossboard_aws_configure_new_clusters.sh
> bash ./krossboard_aws_configure_new_clusters.sh $KB_ROLE_ARN
> ```

## Get Access to Krossboard UI
The Krossboard web interface is available port `80` by default. 

 > To access it you would first edit the instance's security group rules to enable HTTP access on that port.

Once the security group rules properly configured, open a browser tab and point it to this URL `http://instance-addr/`. Change **instance-addr** to the IP address of the Krossboard instance.

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