+++
title = "Releases Information"
description = ""
draft = false
weight = 100
toc = true
+++

This page lists important features and changes about Krossboard releases.

## Krossboard v1.1.x
This major branch (current version: `v1.1.1`) brings the below changes.

* **Support any Kubernetes distributions** (e.g. EKS, AKS, EKS, OpenShift, Rancker RKE and vailla Kubernetes).
* **Support on-premises deployments and cloud-cloud analytics**, thanks to a generic configuration though a KUBECONFIG file. This new configuration approach complements the existing one based on automatic discovery of against managed Kubernetes on GKE, EKS and AKS.
* **New distribution packages** based on ready-to-deploy OVF appliance images and setup packages for Ubuntu Server 18.04 LTS.
* **Added monthly analytics reports** for cluster-consolidated usage. 
* Check out the [**documentation**]({{< relref "/docs/" >}}) to find resources to deploy Krossboard or to [**update an existing instance**]({{< relref "/docs/update" >}}).

## Krossboard v1.0.0
This is the first release of Krossboard bringing out the following set of features.

* **Automatic discovery and centralized usage analytics for managed Kubernetes clusters**, which currently includes [Amazon EKS](https://aws.amazon.com/eks/), [Azure AKS](https://azure.microsoft.com/services/kubernetes-service/) and [Google GKE](https://cloud.google.com/kubernetes-engine).
* **Per cluster and cross namespace usage analytics:** provides stacked hourly, daily and monthly reports for each namespace and with the reporting period covering up to one year.
* **Global and cross cluster usage analytics:** shows stacked cluster-scoped hourly usage on a user-defined period of time given by a start date and an end date.
* **Ability to export any generated reports in CSV format:** allows each enterprise or organization to leverage their favorite data analytics tools to extract additional insights.
* **Easy deployment through public cloud images:** currently supported cloud providers are, Amazon Web Services (AWS), Google Compute Platform (GCP) and Microsoft Azure.

## Latest Cloud Images
This section lists cloud images published for Amazon AWS, Google GCP, Microsoft Azure.

### Amazon AWS images
This table lists AWS regions where official Krossboard AMIs are currently released. During the [installation]({{< relref "/docs/deploy-for-amazon-eks" >}}), you must select a region listed in this table by setting the variable `KB_AWS_REGION`.

| Region          | Krossboard Version       | Build ID         |
| --------------- |:------------------------:| ----------------:|
| ap-southeast-1  | v1.1.1                   | 09606ec          |
| ap-southeast-2  | v1.1.1                   | 09606ec          |
| ca-central-1    | v1.1.1                   | 09606ec          |
| eu-central-1    | v1.1.1                   | 09606ec          |
| eu-west-1       | v1.1.1                   | 09606ec          |
| eu-west-2       | v1.1.1                   | 09606ec          |
| sa-east-1       | v1.1.1                   | 09606ec          |
| us-east-1       | v1.1.1                   | 09606ec          |
| us-west-1       | v1.1.1                   | 09606ec          |

### Google GCP images
This table lists the current Krossboard images available on GCP.

| Region    | Krossboard version   | Build ID         |
| ----------|:--------------------:| ----------------:|
| Global    | v1.1.1                | 09606ec          |

### Microsoft Azure images
On Microsoft Azure, Krossboard is released through a [Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/shared-image-galleries).

The [setup script]({{< relref "/docs/deploy-for-azure-aks" >}}) does always deploy the latest version of the image. You just have to define the location via the variable `KB_AZURE_LOCATION`. See the list of locations below.


| Replication regions   | Krossboard version   | Build ID         |
| ----------------------|:--------------------:| ----------------:|
| brazilsouth           | v1.1.1               | 09606ec          |
| canadacentral         | v1.1.1               | 09606ec          |
| centralindia          | v1.1.1               | 09606ec          |
| centralus             | v1.1.1               | 09606ec          |
| germanywestcentral    | v1.1.1               | 09606ec          |
