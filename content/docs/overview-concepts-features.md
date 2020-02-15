+++
title = "Overview, Concepts & Features"
description = ""
draft = false
weight = 40
toc = true 
+++


## What is Krossboard
Krossboard is an original centralized resource usage analytics tool for managed Kubernetes clusters. Currently supported on Amazon EKS, Google GKE, and Microsoft AKS, it's intended to be gradually extended to support other public clouds and on-premise clusters. Krossboard is meant to help organizations to tackle cost allocation and capacity planning decisions with unique benefits.

![](/images/docs/krossboard-architecture-overview.png)

## Unique benefits
Key benefits of Krossboard include, without being limited to, the following:

* **Ease cost allocation decisions**: Krossboard provides detailed reports on resources consumed by each project/application during various accounting periods (hourly, daily, monthly), thereby helping to share infrastructure and operations costs among your organization projects and/or business units.
* **Help anticipate costs**: Krossboard features dynamic analytics reports that show how resources are being consumed over time. This helps organizations to forecast scaling up/down, hence to anticipate the related costs.
* **Enabler for cloud-cost reduction strategy**: Krossboard helps make clusters consolidation decisions by giving factual insights that show how the clusters of your organization are utilized over time. These insights can then be used to motivate and drive consolidation decisions for clusters that are used in a non-efficient way, leading to infrastructure and operations costs reduction.

## Simple integration yet robust tool
Krossboard brings original concepts built in a robust and easy-to-integrate tool. Its core architecture can be described by the next key characteristics:

* **Deploy in minutes, once for all your clusters**: 
    Krossboard is an integrated system easily deployable from any cloud provider's marketplace. It's currently supported on Amazon EKS, Google GKE and Microsoft AKS. Once installed, it automates the discovery of your Kubernetes clusters to centralize the analytics of their resource usage at a single place.
* **Consistent analytics**: 
    For each cluster, Krossboard regularly collects instantaneous usage metrics, aggregate and consolidate them over time, to produce, short-term (hourly), mid-term (daily) and long-term (monthly) analytics perspectives that cover periods up to a year.
* **Efficient Visualization at a Central place**: 
    For each and all of your clusters, Krossboard produces friendly analytics dashboards with various charts and consolidated reports that help each organization to understand which share of resources each project/application is spending. Actually, at any point or period of time during the year, your organization can leverage relevant insights for accounting, cost allocation and capacity planning.
* **User-extensible analytics**: Aware that organizations may need specific analytics that are not natively built in Krossboard, it's designed to feature the ability to export any data its generates in CSV format; those data can further be processed to extract additional insights.

## Established analytics paradigms
Krossboard extends our breadth and depth expertises with [Kubernetes Opex Analytics](https://github.com/rchakode/kube-opex-analytics). The former keeps the main core design principles of the latter -- which is already broadly adopted by an established community, and add further capabilities that make it unique and effective for public clouds and multi-cluster environments.

Here is a non-exhautive list of these core principles:

* **Namespace-focused:**
    Means that consolidated resource usage metrics consider individual namespaces as fundamental units for resource sharing. A special care is taken to also account and highlight *non-allocatable* resources.
* **Hourly Usage & Trends:** 
    Like on public clouds, resource use for each namespace is consolidated on a hourly-basic. This actually corresponds to the ratio (%) of resource used per namespace during each hour. We think that this is a relevant foundation for cost calculation and capacity planning for Kubernetes resources.
* **Daily and Monthly Usage:** 
    This provides for each, period (daily/monthly), namespace, and resource type (CPU/memory), consolidated cost indicators. These indicators are computed as accumulated hourly usage over that period of time.
   

## Easy to Getting Started
According to your cloud provider, consider one of these guides:

* [Installation for Amazon AKS]({{< relref "/docs/amazon-eks-installation" >}})
* [Installation for Azure EKS]({{< relref "/docs/azure-aks-installation" >}})
* [Installation for Google GKE]({{< relref "google-gke-installation" >}})

Get started now  and make your journey with Kubernetes usage analytisc easy.