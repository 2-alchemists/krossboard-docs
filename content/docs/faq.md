+++
title = "Frequently Asked Questions"
description = ""
draft = false
weight = 900
toc = true 
+++

This page answers questions users frequently.

## What permissions does Krossboard need to operate?
After the installation, Krossboard basically needs read-only permissions to the following Kubernetes API to work properly:

* /apis/metrics.k8s.io/v1beta1
* /api/v1

In addition to that, it's deployed against managed Kubernetes (e.g. GKE, EKS, AKS) with the automatic discovery capabilities, it also needs appropriate cloud IAM permissions to discover and handle your managed Kubernetes. That are also read-only permissions. You can review the [setup scripts](https://github.com/2-alchemists/krossboard/tree/master/tooling-scripts/setup) to have the details of those permissions.

However, when you deploy it, notably on clouds (e.g. GCP, AWS, Azure), you would likely need according to your cloud provider some  administrations permissions to deploy and configure the instance.

## What is the license?


## Does Krossboard is free?