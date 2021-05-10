+++
title = "Namespace Usage Analytics"
description = ""
weight = 10
draft = false
bref = ""
toc = false
aliases = ["/docs/namespace-scoped-analytics-charts-and-reports/"]
+++

For each Kubernetes cluster it handles, Krossboard provides the following kinds of charts and reports at the namespace level.
  * Usage Trends & History (hourly)
  * Usage Accounting (daily, monthly).

> **Data Export.** The data backing the different charts can be exported in CSV format. This enables the ability to further process them with your favorite third-party data analytics like [Google BigQuery](https://cloud.google.com/bigquery), [AWS Athena](https://aws.amazon.com/athena/), [Azure Synapse](https://azure.microsoft.com/en-us/services/synapse-analytics/), [Tableau](https://www.tableau.com/), [Microsoft Excel](https://www.microsoft.com/en-us/microsoft-365/excel#pivot-forPersonal), to list a few.

## Recent Consolidated Usage
This section displays pie charts showing the latest consolidated CPU and memory usage. Updated every 5 minutes, these reports highlight shares of used, available, and non-allocatable resources.

![](/images/docs/screenshorts/krossboard-current-usage-overview.png)

## Usage Trends & Accounting
For each cluster (that the user can select on-demand), this section displays the hourly usage trends and also the usage accounting per day and per month. While the daily accounting does cover the last two weeks, the monthly accounting does covers a period of the last 12 months (i.e. a year of usage).

To export the backing data in CSV, you just have to click on the links next to the cluster list.

![](/images/docs/screenshorts/krossboard-cluster-usage-trends.png)


## Other Resources
* [Krossboard Analytics and Data Export]({{< relref "02_analytics-and-data-export" >}})
* [Setup Krossboard for Amazon EKS]({{< relref "50_deploy-for-amazon-eks" >}})
* [Setup Krossboard for Azure AKS]({{< relref "30_deploy-for-azure-aks" >}})
* [Setup Krossboard for Google GKE]({{< relref "20_deploy-for-google-gke" >}})
* [Setup Krossboard for Cross-Cloud or On-premises Kubernetes]({{< relref "60_deploy-for-cross-cloud-and-on-premises-kubernetes" >}})