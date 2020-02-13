+++
title = "Krossboard Core Concepts"
description = ""
weight = 50
draft = true
bref = ""
toc = true 
aliases= ["/docs/how-data-are-collected-and-consolidated/"]
+++


Krossboard extends our breadth and depth expertises with [Kubernetes Opex Analytics](https://github.com/rchakode/kube-opex-analytics). It keeps the main core design principles of Kubernetes Opex Analytics that have been already adopted by a large community as an original approach of doing usage analytics on Kubernetes clusters.

Here is a non-exhautive list of these core principles:

* **Namespace-focused:**
    Means that consolidated resource usage metrics consider individual namespaces as fundamental units for resource sharing. A special care is taken to also account and highlight *non-allocatable* resources.
* **Hourly Usage & Trends:** 
    Like on public clouds, resource use for each namespace is consolidated on a hourly-basic. This actually corresponds to the ratio (%) of resource used per namespace during each hour. We think that this is a relevant foundation for cost calculation and capacity planning for Kubernetes resources.
* **Daily and Monthly Usage:** 
    This provides for each, period (daily/monthly), namespace, and resource type (CPU/memory), consolidated cost indicators. These indicators are computed as accumulated hourly usage over that period of time.
* **Efficient Visualization:** 
    For analytics generate, Krossboard provides dashboards with various type of charts and reports, covering as well the last couple of hours than the last 12 months. This allows to organizations at each period of the year, to leverage relevant insights for accounting balance sheets.


Get started now by [installing your instance of Krossboard]({{< relref "/docs" >}}), make your journey with Kubernetes usage analytisc easy.