+++
title = "Overview of Krossboard"
description = ""
draft = false
+++


## What is Krossboard
Krossboard is an original centralized resource usage analytics tool for managed Kubernetes clusters. It's currently supported on Amazon EKS, Google GKE, Microsoft AKS, and is intended to be gradually extended to support other public clouds and on-premise clusters.

## Benefits of Krossboard
Krossboard is meant to be a leading cost allocation and capacity planning tool with unique benefits for organizations.

* **Ease cost allocation decisions**: Krossboard provides detailed reports on resources consumed by each project/application during various accounting periods (hourly, daily, and monthly).
* **Help anticipate costs**: Krossboard features dynamic analytics reports that show how resources are consumed over time. This helps organizations to forecast cluster scaling up/down, hence to anticipate the related costs.
* **Enabler for cloud-cost reduction strategy**: Krossboard helps make cluster consolidation decisions by giving factual insights that show how clusters are utilized. Organizations can so easily motivate and drive consolidation decisions for clusters that are underutilized or used in a non-efficient way. Hence they would reduce their infrastructure and operations costs.

## How Krossboard Works
Krossboard brings simple yet powerful concepts that make it integration easy to your Kubernetes cloud environments. 

* **Integrated system packaged as Marketplace appliance**: Krossboard is designed to be easily deployed from your cloud provider's marketplace. It currently works on Amazon EKS, Google GKE, Microsoft AKS. Once installed, it automates the discovery of your Kubernetes clusters to centralize the analysis of their resource usage at a single place.
* **Consistent analytics**: for each cluster, it computes resource usage for each individual namespace and aggregates a hourly basics (common cloud billing unit), and render short term (hourly basis), mid term (daily basis) and long term (monthly basis) consolidated analytics perspectives that cover up to a year).
* **Central place of visualization**: Beyond the advanced aggregation and consolidation capabilities that Krossboard features, it renders its analytics as friendly chart reports. That help each organization to understand at any point of time, which projects/applications are spending Kubernetes costs. Its graphical interface also features an entry point as a panel of glass to get instantaneous insights on the level of usage of each individual  clusters.