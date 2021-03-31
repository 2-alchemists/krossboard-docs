+++
title = "Krossboard - Core Analytics"
description = ""
draft = false
weight = 1
toc = true
aliases = ["/docs/analytics-dashboards-and-data-export/"]
+++

For all your Kubernetes clusters set through one or more KUBECONFIG files, Krossboard builds and provides purposely-designed resources utilization analytics for the different clusters.

* [**Namespaces Usage Analytics**]({{< relref "/docs/10_namespace-scoped-analytics" >}}): These analytics enabled at the scope of each Kubernetes cluster tracks the resource utilization by the different namespaces composing the cluster. When applicable, the analytics data and charts also highlight the share of `non-allocatable` resources (in the Kubernetes jargon, `non-allocatable` resources are those reserved and dedicated for the operations of Kubernetes components). The tracking allows visualizing and easily understand the history of usage for the different nodes over time.
* [**Nodes Usage Analytics**]({{< relref "/docs/11_node-scoped-analytics.md" >}}): These analytics enabled at the scope of each Kubernetes cluster tracks the resource utilization by pods on the different nodes. The tracking allows visualizing and easily understand recent usage (5-minutes consolidated) and also the history of usage for the different nodes over time.
* [**Clusters Usage Analytics**]({{< relref "/docs/12_cluster-scoped-analytics" >}}): These analytics enabled at the scope of one or more Kubernetes clusters tracks and helps to compare the level of resource utilization across those clusters. The tracking allows visualizing and easily understand recent usage (5-minutes consolidated) and also the history of usage for the different clusters over time.

Krossboard analytics are designed to be consistent and insightful. Involving metrics consolidation and presentation with consolidated time perspectives (minutes, hours, days, months), we aim to help organizations understand how their different projects and applications are consuming their Kubernetes resources over time. Ultimately, the enabled analytics data and reports are there to provide core foundation to easily tackle cost allocation and capacity planning decisions. 

