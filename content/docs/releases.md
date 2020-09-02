+++
title = "Releases Resources"
description = ""
draft = false
weight = 100
toc = true 
+++

This page lists important features and changes about Krossboard releases.

## Krossboard v1.0.0
This is the first release of Krossboard bringing out the following features:

* **Automatic discovery and centralized usage analytics for managed Kubernetes clusters**, which currently includes [Amazon EKS](https://aws.amazon.com/eks/), [Azure AKS](https://azure.microsoft.com/services/kubernetes-service/) and [Google GKE](https://cloud.google.com/kubernetes-engine).
* **Per cluster and cross namespace usage analytics:** provides stacked hourly, daily and monthly reports for each namespace and with the reporting period covering up to one year.
* **Global and cross cluster usage analytics:** shows stacked cluster-scoped hourly usage on a user-defined period of time given by a start date and an end date.
* **Ability to export any generated reports in CSV format:** allows each enterprise or organization to leverage their favorite data analytics tools to extract additional insights.
* **Easy deployment through public cloud images:** currently supported cloud providers are, Amazon Web Services (AWS), Google Compute Platform (GCP) and Microsoft Azure.

## Available images
This section lists images currently available for Amazon AWS, Google GCP, Microsoft Azure.


### Amazon AWS images
This table lists AWS regions where official Krossboard AMIs are currently released. During the [installation]({{< relref "/docs/deploy-for-amazon-eks" >}}), you must select a region listed in this table by setting the variable `KB_AWS_REGION`.

| Region          | Krossboard Version       | Build ID         |
| --------------- |:------------------------:| ----------------:|
| ap-southeast-1  | v1.0.0                   | c99157f          |
| ap-southeast-2  | v1.0.0                   | c99157f          |
| ca-central-1    | v1.0.0                   | c99157f          |
| eu-central-1    | v1.0.0                   | c99157f          |
| eu-west-1       | v1.0.0                   | c99157f          |
| eu-west-2       | v1.0.0                   | c99157f          |
| sa-east-1       | v1.0.0                   | c99157f          |
| us-east-1       | v1.0.0                   | c99157f          |
| us-west-1       | v1.0.0                   | c99157f          |

### Google GCP images
This table lists the currently supported GCP images for Krossboard.
During the [installation]({{< relref "/docs/deploy-for-google-gke" >}}), you can set a specific image listed in this table by setting the variable `KB_GCP_IMAGE`.

| Region    | Krossboard version   | Build ID         |
| ----------|:--------------------:| ----------------:|
| Global    | v1.0.0                | c99157f          |

### Microsoft Azure images
On Microsoft Azure, Krossboard is released through a [Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/shared-image-galleries).

The [setup script]({{< relref "/docs/deploy-for-azure-aks" >}}) does always deploy the latest version of the image. The location of the instance, set via the variable `KB_AZURE_LOCATION`, must match one of availability locations listed in the following table.


| Replication regions   | Krossboard version   | Build ID         |
| ----------------------|:--------------------:| ----------------:|
| Brazil South          | v1.0.0               | c99157f          |
| Canada Central        | v1.0.0               | c99157f          |
| Central India         | v1.0.0               | c99157f          |
| Central US            | v1.0.0               | c99157f          |
| East US               | v1.0.0               | c99157f          |
| Germany West Central  | v1.0.0               | c99157f          |
| Korea Central         | v1.0.0               | c99157f          |
| UK West               | v1.0.0               | c99157f          |
| West US               | v1.0.0               | c99157f          |
