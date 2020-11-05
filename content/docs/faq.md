+++
title = "Frequently Asked Questions"
description = ""
draft = false
weight = 900
toc = true 
+++

This page answers questions users may have.

## What permissions does Krossboard need to operate?
To work properly, Krossboard basically needs read-only permissions to the following Kubernetes API:

* /apis/metrics.k8s.io/v1beta1
* /api/v1

For a fine-grained permissions set with the required permissions, the credentials can be configured using the following ClusterRole and ClusterRoleBindding definition. definition.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: krossboard
  labels:
    app: krossboard
rules:
- apiGroups:
  - ""
  resources:
  - namespaces
  - nodes
  - pods
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - metrics.k8s.io
  resources:
  - nodes
  - nodes/stats
  - pods
  verbs:
  - get
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: krossboard
  labels:
    app: krossboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: krossboard
subjects:
- kind: ServiceAccount
  name: krossboard
```

Any KUBECONFIG file with credentials allowing this minimum set of permissions should be sufficient.

## How does autodiscovery work with managed Kubernetes (GKE, AKS, EKS)
When deployed to automatically discover and handle managed Kubernetes (GKE, AKS, EKS), Krossboard requires appropriate cloud IAM permissions. 
These are read-only permissions. You can review the [setup scripts](https://github.com/2-alchemists/krossboard/tree/master/tooling-scripts/setup) to get more details.

However, during the deployment, administration permissions on the cloud platform are required to configure the instance with appropriate privileges.

## What are requirements to run Krossboard
* Ubuntu Server 18.04
* Docker 19.03 or higher
* 2 vCPU and 1024MB (recommendation for 10+ clusters).

## The Krossboard UI seems to be not reachable
Connect with SSH on the instance and restart the service:

```sh
sudo systemctl restart krossboard-ui
```

## How to uninstall Krossboard from cloud environement (GCP, AWS, Azure)
If your Krossboard instance has been deployed against managed Kubernetes (e.g. Google GKE, Microsoft AKS or AWS EKS), the deployment script ends up with a summary listing all the cloud resources created during the installation (e.g. IAM role, security group, service account, etc.).

If you want to completely remove Krossboard from your cloud environment, you just have to remove all those resources.

## What are the terms of use?
The Krossboard terms of use are described in the NOTICE file available on its [Github repository](https://github.com/2-alchemists/krossboard). 

These terms of use are subject to changes at any time.