+++
title = "Frequently Asked Questions"
description = ""
draft = false
weight = 999
toc = true
aliases = ["/docs/faq/"]
+++

This page answers to some classical questions regarding Krossboard.

## What are the terms of use?
Krossboard is subject to terms of use described in the NOTICE file, which is available in each release package and via our [GitHub Page](https://github.com/2-alchemists/krossboard).

These terms of use are subject to change and may be applicable for specific versions of Krossboard.

## What permissions does Krossboard need on Kubernetes clusters?
To operate properly, Krossboard does basically need **read-only access** to the following permissions Kubernetes APIs:

* `/apis/metrics.k8s.io/v1beta1`
* `/api/v1`

For a fine-grained and least permissions set, the KUBECONFIG files provided to Krossboard can be configured with a user and service account bound to the following ClusterRole and ClusterRoleBindding. 

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

## How does autodiscovery work with managed Kubernetes (GKE, AKS, EKS)
When deployed to automatically discover and handle managed Kubernetes (GKE, AKS, EKS), Krossboard requires appropriate cloud IAM permissions. 
These are read-only permissions. You can review the [setup scripts](https://github.com/2-alchemists/krossboard/tree/master/tooling-scripts/setup) to get more details.

However, during the deployment, administration permissions on the cloud platform are required to configure the instance with appropriate privileges.

## What are system requirements for an Krossboard instance
The following system configuration would be sufficient to run a Krossboard instance to support 10+ Kubernetes clusters.

* Ubuntu Server 18.04
* Docker 19.03 or higher
* 2 vCPU and 1024MB (recommendation for 10+ clusters).

## How to uninstall Krossboard from cloud environment (GCP, AWS, Azure)
If your Krossboard instance has been deployed against managed Kubernetes (e.g. Google GKE, Microsoft AKS or AWS EKS), the deployment script ends up with a summary listing all the cloud resources created during the installation (e.g. IAM role, security group, service account, etc.).

If you want to completely remove Krossboard from your cloud environment, you just have to remove all those resources.

## How to handle multiple KUBECONFIG files
Krossboard natively handles multiple KUBECONFIG files without additional configuration settings. 

You only need to copy your KUBECONFIG files in the folder `/opt/krossboard/data/kubeconfig.d` on the Krossboard instance.