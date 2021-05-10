+++
title = "Node Usage Analytics"
description = ""
weight = 11
draft = false
bref = ""
toc = false
aliases = ["/docs/node-scoped-analytics-charts-and-reports/"]
+++

For the different Kubernetes clusters handled, this page provides node usage analytics with the following perspectives:

* Recent node occupation by pods
* Node usage history for a user-selectable period of time.

## Recent Node Occupation by Pods
This section of provides for each cluster selected on-demand (1), the latest-captured resource usage by pods running on the different nodes (2).

For each node, the analytics is rendered as a pie-chart given for CPU and memory the ratio resources of used by every running pod, the ratio of available/free resources, and the ratio of `non-allocatable` capacity.

![krossboard-node-recent-occupation.png](/images/docs/screenshorts/krossboard-nodes-recent-occupation-by-pods.png)

## Usage History
This section of provides for each cluster selected on-demand (1), the history of consolidated resource capacity available, non-allocatable, and consumed by pods for a user-selectable period of time (the default history period being the last 24 hours). 

For each node, the analytics is rendered as a stacked-areas chart for CPU (4) and memory (5) resources. Over time and for each resource type (CPU, memory), each chart renders, the overall resource capacity enabled by the node, the capacity used by pods, and the remaining/free capacity.

![krossboard-node-usage-history.png](/images/docs/screenshorts/krossboard-nodes-usage-history.png)


## Other Resources
* [Krossboard Analytics and Data Export]({{< relref "02_analytics-and-data-export" >}})
* [Setup Krossboard for Amazon EKS]({{< relref "50_deploy-for-amazon-eks" >}})
* [Setup Krossboard for Azure AKS]({{< relref "30_deploy-for-azure-aks" >}})
* [Setup Krossboard for Google GKE]({{< relref "20_deploy-for-google-gke" >}})
* [Setup Krossboard for Cross-Cloud or On-premises Kubernetes]({{< relref "60_deploy-for-cross-cloud-and-on-premises-kubernetes" >}})
