+++
title = "Krossboard Concepts & Key Features"
description = ""
draft = false
weight = 1
toc = true 
+++

![](/images/docs/krossboard-architecture-overview.png)

Krossboard is an original centralized resource usage analytics tool for managed [Kubernetes](https://kubernetes.io/) clusters.

Currently supported on [Amazon EKS](https://aws.amazon.com/eks/), [Google GKE](https://cloud.google.com/kubernetes-engine) and [Azure AKS](https://azure.microsoft.com/services/kubernetes-service/), it's intended to be gradually extended to support other public clouds and on-premise clusters. Krossboard is meant to help organizations to tackle cost allocation and capacity planning decisions with unique benefits.

## Unique benefits
Without being exhaustive here are some key benefits of Krossboard:

* **Ease cost allocation decisions**: Krossboard provides detailed reports on resources consumed by each project/application during various accounting periods (hourly, daily, monthly), thereby helping organizations to share infrastructure and operations costs among their projects and/or business units.
* **Help anticipate costs**: Krossboard features dynamic analytics reports that show how resources are being consumed over time. This helps organizations to forecast scaling up/down, hence to anticipate the related costs.
* **Enabler for cloud-cost reduction strategy**: Krossboard helps make clusters consolidation decisions by giving factual insights that show how the clusters of your organization are utilized over time. These insights can then be used to motivate and drive consolidation decisions for clusters that are used in a non-efficient way, leading to reducing infrastructure and operations costs.

## Simple integration, yet a robust tool
Krossboard brings original concepts built in a *robust tool with an easy-to-integrate architecture*:

* **Deploy in minutes, for Multiple clusters**: Krossboard is an integrated easy-to-deploy tool. Released as ready-to-install virtual machine appliances, cloud images and  binary packages, its deployment only needs a couple of minutes. When deployed on cloud environments, it can automatically discover and handle your managed Kubernetes instances. This capability is currently supported for Amazon EKS, Google GKE and Microsoft AKS.
* **Cross-cloud and cross-distribution, Unified analytics**: Krossboard can run against any Kubernetes distributions, all mixed together or not. This unique design enables organizations to set up a global strategy to track and understand how their Kubernetes resources are used by their different projects.
* **Consistent Analytics**: For each cluster it handles, Krossboard regularly collects instantaneous usage metrics, then aggregated and consolidated over time, to produce, short-term (hourly), mid-term (daily) and long-term (monthly) analytics perspectives that cover periods up to a year.
* **Efficient Visualization at a Central place**: For each and all of your clusters, Krossboard produces friendly analytics dashboards with various charts and consolidated reports that help each organization to understand which share of resources each project/application is spending. Actually, at any point or period of time during the year, your organization can leverage relevant insights for accounting, cost allocation and capacity planning.
* **User-extensible analytics**: Aware that organizations may need specific analytics that are not natively built in Krossboard, it's designed to feature the ability to export any data its generates in CSV format; those data can then be further processed to extract additional insights.

## Established analytics paradigms
With its foundation in [kube-opex-analytics](https://github.com/rchakode/kube-opex-analytics) -- which is already adopted by an established community, Krossboard incorporates the main analytics principles of kube-opex-analytics at its core. Leveraging also our depth and breadth experience developing and managing applications on Kubernetes, Krossboard enables further capabilities that make it unique and effective for environments with multiple Kubernetes clusters.

* **Namespace-focused:**
    Means that consolidated resource usage metrics consider individual namespaces as fundamental units for resource sharing. A special care is taken to also account and highlight *non-allocatable* resources.
* **Hourly Usage & Trends:** 
    Like on public clouds, resource use for each namespace is consolidated on a hourly basis. This actually corresponds to the ratio (%) of resource used per namespace during each hour. We think that this is a relevant foundation for cost calculation and capacity planning for Kubernetes resources.
* **Daily and Monthly Usage:** 
    This provides for each, period (daily/monthly), namespace, and resource type (CPU/memory), consolidated cost indicators. These indicators are computed as accumulated hourly usage over that period of time.

## Getting Started
Consider one of the following resources to deploy Krossboard for your managed Kubernetes.

* [Setup Krossboard for Amazon EKS]({{< relref "/docs/deploy-for-amazon-eks" >}})
* [Setup Krossboard for Azure AKS]({{< relref "/docs/deploy-for-azure-aks" >}})
* [Setup Krossboard for Google GKE]({{< relref "deploy-for-google-gke" >}})

