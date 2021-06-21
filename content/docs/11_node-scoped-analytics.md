+++
title = "Node Usage Analytics"
description = ""
weight = 11
draft = false
bref = ""
toc = false
aliases = ["/docs/node-scoped-analytics-charts-and-reports/"]
+++

For the different Kubernetes clusters tracked, this page provides node usage analytics with the following perspectives:

* Recent nodes occupation by pods.
* Node usage history by user-defined period of times.

> Please note that the activation of these features requires a valid license.

## Recent Node Occupation by Pods
This dashboard is displayed by selecting a node (1) and the option `Nodes recent occupation` (2).

For the selected node, the analytics render a piechart report for CPU and memory consumption (3).

On each report piechart we have:

  * The ratio of resources used by the different running pods.
  * The ratio of available resources.
  * The ratio of `non-allocatable` capacity.

![krossboard-node-recent-occupation.png](/images/docs/screenshorts/krossboard-nodes-recent-occupation-by-pods.png)

## Usage History
This dashboard is enabled by selecting a cluster (1) and a user-defined period of time (default is the last 24 hours).

For each node, we have a chart for CPU (4) and memory (5) resources rendered as a stacked-areas chart. 

Each chart displays and helps understand the following metrics hourly-consolidated over time (i.e. as historical trends): 

 * Overall capacity enabled by the node.
 * Capacity consumed by pods.
 * Available/free capacity. 
 * Non-allocatable capacity. 

![krossboard-node-usage-history.png](/images/docs/screenshorts/krossboard-nodes-usage-history.png)


## Other Resources
* [Krossboard Analytics and Data Export]({{< relref "02_analytics-and-data-export" >}})
* [Setup Krossboard for Amazon EKS]({{< relref "50_deploy-for-amazon-eks" >}})
* [Setup Krossboard for Azure AKS]({{< relref "30_deploy-for-azure-aks" >}})
* [Setup Krossboard for Google GKE]({{< relref "20_deploy-for-google-gke" >}})
* [Setup Krossboard for Cross-Cloud or On-premises Kubernetes]({{< relref "60_deploy-for-cross-cloud-and-on-premises-kubernetes" >}})
