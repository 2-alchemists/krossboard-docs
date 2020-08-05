+++
title = "Setup Krossboard for Amazon EKS"
description = ""
weight = 10
draft = false
bref = ""
toc = true 
+++

On Amazon AWS, Krossboard works as a standalone EC2 virtual machine. 
Once installed and properly configured, an instance does automatically discover and handle all EKS clusters in the [AWS region](https://docs.aws.amazon.com/en_us/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) it belongs to. 

This guide describes step-by-step how to deploy and configure Krossboard for an AWS region. 

## Before you begin
This installation guide assumes that:

* You have a basic level of practice with AWS concepts.
* You can have access to AWS Management Console and to AWS CLI with sufficient permissions: (1) to create and assign AWS IAM roles; (2) to create EC2 instances; and (3) to access to AKS clusters in the selected region.
* You have [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/) installed and accessible from your terminal.
* You have **[jq](https://stedolan.github.io/jq/)** installed on your terminal. 

> All the next steps are achieved from a terminal.

## Start a Krossboard instance
Run the enclosed command to create your instance of Krossboard, beforehand review the parameters and adapt them if applicable.
  * Set a proper key pair (variable `AWS_EC2_KEY_PAIR` accordingly). If you want to create a new key pair, read [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html).
  * The deployment region (variable `AWS_EKS_REGION`) should be where your target EKS clusters are located.
  * A `t2.small` instance type is a good starting point, unless you have 10+ EKS clusters with many namespaces in the same region.

```sh
AWS_EC2_TYPE='t2.small'
AWS_EC2_KEY_PAIR='MyKeyPair'
AWS_EKS_REGION='eu-central-1'
KB_IMAGE='ami-0fa8675e6d205da2b'
KB_INSTANCES_INFO=$(aws ec2 run-instances --region "$AWS_REGION" --image-id "$KB_IMAGE" --instance-type "$AWS_EC2_TYPE" --key-name "$AWS_EC2_KEY_PAIR" --count 1)
```

### Configure IAM permissions for Krossboard

Create the policy and the trust relationship policy files

```bash
cat <<EOF > /tmp/kb-policy.json
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
EOF

cat <<EOF > /tmp/kb-rtp.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
```

Create the IAM role and associated it to the instance.

```bash
ROLE_NAME='krossboard-role'
KB_POLICY=$(aws iam create-policy --policy-name krossboard-policy --policy-document file:///tmp/kb-policy.json)
KB_ROLE=$(aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file:///tmp/kb-rtp.json)
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$(echo $KB_POLICY | jq -r '.Policy.Arn')"
aws iam create-instance-profile --instance-profile-name "${ROLE_NAME}-profile"
aws iam add-role-to-instance-profile --role-name "$ROLE_NAME" --instance-profile-name "${ROLE_NAME}-profile"
# The role profile or the instance may not be ready immediately
# That's why the next command is retried a couple of times
n=0
until [ "$n" -ge 15 ]
do
   aws ec2 associate-iam-instance-profile --instance-id "$(echo $KB_INSTANCES_INFO | jq -r '.Instances[0].InstanceId')" --iam-instance-profile Name="${ROLE_NAME}-profile" && break
   n=$((n+1)) 
   sleep 1
done
```

### Configure metrics retrieval from EKS clusters
> This step must be achieved on each cluster.

**Deploy Kubernetes Metric Server**

```bash
DOWNLOAD_VERSION=v0.3.6
DOWNLOAD_URL=https://api.github.com/repos/kubernetes-sigs/metrics-server/tarball/${DOWNLOAD_VERSION}
curl -Ls $DOWNLOAD_URL -o metrics-server-$DOWNLOAD_VERSION.tar.gz
mkdir metrics-server-$DOWNLOAD_VERSION
tar -xzf metrics-server-$DOWNLOAD_VERSION.tar.gz --directory metrics-server-$DOWNLOAD_VERSION --strip-components 1
kubectl apply -f metrics-server-$DOWNLOAD_VERSION/deploy/1.8+/
```

Verify that installation has been successful.

```bash
kubectl -nkube-system get deploy metrics-server
```

**Configure permissions (EKS RBAC) to enable access to metrics**

This step implies to edit the **aws-auth** ConfigMap of the EKS cluster.

Before any changes, we do recommend to backup the current **aws-auth** ConfigMap.

```bash
kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-backup-$(date +%F).yaml
```

Once the backup done, edit the **aws-auth** ConfigMap.

```bash
kubectl -n kube-system edit configmap aws-auth
```

Add the following lines under the **mapRoles** section, while **replacing** each instance of the snippet **<ARN of Krossboard Role>** with the ARN of the role created previously.

```yaml
    - groups:
      - krossboard-data-processor
      rolearn: <ARN of Krossboard Role>
      username: <ARN of Krossboard Role>
```

At this stage we're almost done, but Krossboard is not yet allowed to retrieve metrics from discovered EKS clusters. The last step is to configure RBAC settings on each EKS cluster to enable the required permissions.

Enable access to metrics

```bash
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-eks.yml
```

## Get Access to Krossboard UI
Open a browser tab and point it to this URL `http://instance-addr/` while replacing **instance-addr** with the IP address of the Krossboard instance.

Here are credentials to log in:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. 
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).