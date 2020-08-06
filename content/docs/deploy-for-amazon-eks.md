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
* You have [`kubectl`](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/), `wget` and [`jq`](https://stedolan.github.io/jq/) installed and accessible from your terminal.

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

### Configure AWS IAM permissions for Krossboard
The following steps would download our policy and the trust relationship policy files for Krossboard, then create the IAM role and associated it to the instance.

```bash
ROLE_NAME='krossboard-role'
wget -O /tmp/${ROLE_NAME}-policy.json https://krossboard.app/artifacts/aws/krossboard-role-policy.json
wget -O /tmp/${ROLE_NAME}-trust-policy.json https://krossboard.app/artifacts/aws/krossboard-role-trust-policy.json
KB_POLICY=$(aws iam create-policy --policy-name krossboard-policy --policy-document file:///tmp/${ROLE_NAME}-policy.json)
KB_ROLE=$(aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file:///tmp/${ROLE_NAME}-trust-policy.json)
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$(echo $KB_POLICY | jq -r '.Policy.Arn')"
aws iam create-instance-profile --instance-profile-name "${ROLE_NAME}-profile"
aws iam add-role-to-instance-profile --role-name "$ROLE_NAME" --instance-profile-name "${ROLE_NAME}-profile"
# The role profile or the instance may not be ready immediately.
# That's why the next command that assigned the profile to the instance
# is retried a couple of times.
n=0
until [ "$n" -ge 15 ]
do
   aws ec2 associate-iam-instance-profile --instance-id "$(echo $KB_INSTANCES_INFO | jq -r '.Instances[0].InstanceId')" --iam-instance-profile Name="${ROLE_NAME}-profile" && break
   n=$((n+1)) 
   sleep 1
done
```

Get the ARN of the instance and note it, it'll be needed later in this guide.

```sh
echo $KB_ROLE | jq -r '.Role.Arn'
```


### Configure EKS RBAC to enable metrics retrieval
> This step must be achieved on each cluster.
> 
> All the needed permissions are read-only permissions on nodes and pods metrics.


#### Deploy Kubernetes Metric Server

```bash
DOWNLOAD_VERSION=v0.3.6
DOWNLOAD_URL=https://api.github.com/repos/kubernetes-sigs/metrics-server/tarball/${DOWNLOAD_VERSION}
curl -Ls $DOWNLOAD_URL -o metrics-server-$DOWNLOAD_VERSION.tar.gz
mkdir metrics-server-$DOWNLOAD_VERSION
tar -xzf metrics-server-$DOWNLOAD_VERSION.tar.gz --directory metrics-server-$DOWNLOAD_VERSION --strip-components 1
kubectl apply -f metrics-server-$DOWNLOAD_VERSION/deploy/1.8+/
```

Verify that the installation has been successful.

```bash
kubectl -nkube-system get deploy metrics-server
```


#### Configure EKS RBAC to access metrics

This step implies to edit the **aws-auth ConfigMap** of the EKS cluster.

Before any changes, we highly recommend to backup the current ConfigMap.

```bash
kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-backup-$(date +%F).yaml
ls -l aws-auth-backup-*.yaml
```

Once the backup done, edit the **aws-auth ConfigMap**.

```bash
kubectl -n kube-system edit configmap aws-auth
```

Add the following snippet under the **mapRoles** section, while changing `<ARN of Krossboard Role>` to the ARN of the Krossboard role (it should have been retrieved at the previous section).

```yaml
    - groups:
      - krossboard-data-processor
      rolearn: <ARN of Krossboard Role>
      username: <ARN of Krossboard Role>
```

Finally apply the RBAC settings on Kubernetes.

```bash
kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-eks.yml
```

## Get Access to Krossboard UI
The Krossboard web interface is available port `80` by default. To access it you would first edit the instance's security group rules to enable HTTP access on that port.

Once the security group rules properly configured, open a browser tab and point it to this URL `http://instance-addr/`. Change **instance-addr** to the IP address of the Krossboard instance.

The default username and password to sign in are:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. 
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).