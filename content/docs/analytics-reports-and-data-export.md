+++
title = "Analytics Reports & Data Export"
description = ""
weight = 40
draft = false
bref = ""
toc = true 
+++

## Before you begin

> After a first installation, you may need to wait a while (typically an hour) to have all built-in charts available. This is because [by design]({{< relref "/docs/overview-concepts-features" >}}), Krossboard is thought to provide consitent analytics with an hourly granularity.

The following analytics and reports are featured  (see details in subsequent sections).

* Consolidated Usage & History
* Usage Trends & Accounting
* Consolidated Usage & History

The backing data of each report can be exported in CSV format. Doing so, we add freedom to unlock additional processing and analytics capabilities using your favorite data analysis tools (Google BigQuery, AWS Athena, Azure Synapse, Tableau, Excel, to list a few).

## Global View of Current Usage
For each cluster discovered and handled by Krossboard, this page displays piecharts showing the latest consolidated CPU and memory usage. Those reports -- updated every 5 minutes, highlight shares of resources, used, available and non-allocatable.

## Usage Trends & Accounting
For each cluster -- selected on-demand by the user, this page provides various reports showing, hourly, daily and monthly usage analytics for CPU and memory resources. 

To export the backing data in CSV, click the related link next to the selected cluster (hourly, daily, monthly).
 
## Consolidated Usage & History
This page provides a comprehensive usage reports covering all clusters for a user-defined period of time. The intend of those reports is to provide an at-a-glance visualization to compare the usage of different clusters for any period of time.

To export the backing data in CSV, click the export link next to the selected period.

