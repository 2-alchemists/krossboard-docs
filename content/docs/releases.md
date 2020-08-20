+++
title = "Releases Notes"
description = ""
draft = false
weight = 51
toc = true 
+++

This page lists important features and changes about Krossboard releases.

## Recent releases

### Release/build v20200726t1595767620 (first release)
This first release brings the following features:

* **Automatic discovery and centralized usage analytics for managed Kubernetes clusters**, which currently includes [Amazon EKS](https://aws.amazon.com/eks/), [Azure AKS](https://azure.microsoft.com/services/kubernetes-service/) and [Google GKE](https://cloud.google.com/kubernetes-engine).
* **Per cluster and cross namespace usage analytics:** provides stacked hourly, daily and monthly reports for each namespace and with the reporting period covering up to one year.
* **Global and cross cluster usage analytics:** shows stacked cluster-scoped hourly usage on a user-defined period of time given by a start date and an end date.
* **Ability to export any generated reports in CSV format:** allows each enterprise or organization to leverage their favorite data analytics tools to extract additional insights.
* **Easy deployment through public cloud images:** currently supported cloud providers are, Amazon Web Services (AWS), Google Compute Platform (GCP) and Microsoft Azure.

## List of available images
This section lists images currently available for the different cloud providers.

Review the list to select a version for your Krossboard deployment.

### Images for Google GCP
  * krossboard-beta-v20200726t1595767620 (July 27, 2020)

### Images for Amazon AWS
  * ami-0fa8675e6d205da2b (August 05, 2020)

### Images for Microsoft Azure
  * /subscriptions/89cdfb38-415e-4612-9260-6d095914713d/resourceGroups/krossboard-release/providers/Microsoft.Compute/galleries/KrossboardRelease/images/Krossboard (August 02, 2020)

