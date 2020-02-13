+++
title = "Overview, Concepts & Features"
description = ""
draft = false
weight = 1
toc = true 
+++


## What is Krossboard
Krossboard is an original centralized resource usage analytics tool for managed Kubernetes clusters. It's currently supported on Amazon EKS, Google GKE, Microsoft AKS, and is intended to be gradually extended to support other public clouds and on-premise clusters.

## Etablished core analytics paradigms
Krossboard extends our breadth and depth expertises with [Kubernetes Opex Analytics](https://github.com/rchakode/kube-opex-analytics). It keeps the main core design principles of Kubernetes Opex Analytics; that is already adopted by a established community as an original approach of doing usage analytics on Kubernetes clusters.

Here is a non-exhautive list of these core principles:

* **Namespace-focused:**
    Means that consolidated resource usage metrics consider individual namespaces as fundamental units for resource sharing. A special care is taken to also account and highlight *non-allocatable* resources.
* **Hourly Usage & Trends:** 
    Like on public clouds, resource use for each namespace is consolidated on a hourly-basic. This actually corresponds to the ratio (%) of resource used per namespace during each hour. We think that this is a relevant foundation for cost calculation and capacity planning for Kubernetes resources.
* **Daily and Monthly Usage:** 
    This provides for each, period (daily/monthly), namespace, and resource type (CPU/memory), consolidated cost indicators. These indicators are computed as accumulated hourly usage over that period of time.
* **Efficient Visualization:** 
    For analytics generate, Krossboard provides dashboards with various type of charts and reports, covering as well the last couple of hours than the last 12 months. This allows to organizations at each period of the year, to leverage relevant insights for accounting balance sheets.

## Unique benefits
Krossboard is meant to be a leading cost allocation and capacity planning tool with unique benefits for organizations.

* **Ease cost allocation decisions**: Krossboard provides detailed reports on resources consumed by each project/application during various accounting periods (hourly, daily, and monthly).
* **Help anticipate costs**: Krossboard features dynamic analytics reports that show how resources are consumed over time. This helps organizations to forecast cluster scaling up/down, hence to anticipate the related costs.
* **Enabler for cloud-cost reduction strategy**: Krossboard helps make cluster consolidation decisions by giving factual insights that show how clusters are utilized. Organizations can so easily motivate and drive consolidation decisions for clusters that are underutilized or used in a non-efficient way. Hence they would reduce their infrastructure and operations costs.

## Simple integration yet effective tool
Krossboard brings simple yet powerful concepts that make it integration easy to your Kubernetes cloud environments. 

* **Integrated system packaged as Marketplace appliance**: Krossboard is designed to be easily deployed from your cloud provider's marketplace. It currently works on Amazon EKS, Google GKE, Microsoft AKS. Once installed, it automates the discovery of your Kubernetes clusters to centralize the analysis of their resource usage at a single place.
* **Consistent analytics**: for each cluster, it computes resource usage for each individual namespace and aggregates a hourly basics (common cloud billing unit), and render short term (hourly basis), mid term (daily basis) and long term (monthly basis) consolidated analytics perspectives that cover up to a year).
* **Central place of visualization**: Beyond the advanced aggregation and consolidation capabilities that Krossboard features, it renders its analytics as friendly chart reports. That help each organization to understand at any point of time, which projects/applications are spending Kubernetes costs. Its graphical interface also features an entry point as a panel of glass to get instantaneous insights on the level of usage of each individual  clusters.

## Easy to Getting Started

* Installation guide for Amazon AKS
* Installation guide for Azure AKS
* Installation guide for Google GKE

Get started now by [installing your instance of Krossboard]({{< relref "/docs" >}}), make your journey with Kubernetes usage analytisc easy.