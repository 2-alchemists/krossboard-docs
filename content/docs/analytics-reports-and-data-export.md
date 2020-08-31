+++
title = "Analytics Reports & Data Export"
description = ""
weight = 20
draft = false
bref = ""
toc = true 
+++

> After a first installation, you may need to wait a while (typically an hour) to have all built-in charts available. This is because [by design]({{< relref "/docs/overview-concepts-features" >}}), Krossboard is thought to provide consistent analytics with an hourly granularity.


![](/images/docs/screenshorts/krossboard-current-usage-overview.png)

Krossboard currently features the following analytics and reports. They are introduced in detail in the next sections.

* Overview of the recent consolidated usage.
* Per-cluster Usage Trends & Accounting.
* Global Usage Trends & History.
  
> **Data Export.** The data backing each of report can be exported in CSV format. Doing so, Krossboard adds freedom to users to unlock additional analytics capabilities using your favorite data analysis tools ([Google BigQuery](https://cloud.google.com/bigquery), [AWS Athena](https://aws.amazon.com/athena/), [Azure Synapse](https://azure.microsoft.com/en-us/services/synapse-analytics/), [Tableau](https://www.tableau.com/), [Microsoft Excel](https://www.microsoft.com/en-us/microsoft-365/excel#pivot-forPersonal), to list a few).


## Overview of Recent Consolidated Usage
For each cluster discovered and handled by Krossboard, this page displays pie charts showing the latest consolidated CPU and memory usage. Updated every 5 minutes, these reports highlight shares of used, available, and non-allocatable resources.

![](/images/docs/screenshorts/krossboard-current-usage-overview.png)

## Per-cluster Usage Trends & Accounting
For each cluster -- selected on-demand by the user, this page provides various reports showing hourly, daily and monthly usage analytics for CPU and memory resources. 

To export the backing data in CSV, click the related link next to the selected cluster (hourly, daily, monthly).

![](/images/docs/screenshorts/krossboard-cluster-usage-trends.png)
 
## Global Usage Trends & History
This page provides comprehensive usage reports covering all clusters for a user-defined period of time. The intent of these reports is to provide an at-a-glance visualization to compare the usage of different clusters for any period of time.

To export the backing data in CSV, click the export link next to the selected period.

![](/images/docs/screenshorts/krossboard-consolidated-clusters-usage.png)

