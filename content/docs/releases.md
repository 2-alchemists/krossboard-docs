+++
title = "Releases Resources"
description = ""
draft = false
weight = 100
toc = true 
+++

This page lists important features and changes about Krossboard releases.

## Latest release notes
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

| Region          | AMI                      | Build ID         |
| --------------- |:------------------------:| ----------------:|
| ap-southeast-1  | ami-029939ebe5cc6623f    | c99157f          |
| ap-southeast-2  | ami-02f6ad9441832ddaf    | c99157f          |
| ca-central-1    | ami-0d700aa5462414086    | c99157f          |
| eu-central-1    | ami-045f4df12a50b158a    | c99157f          |
| eu-west-1       | ami-0eff2360db48d5a32    | c99157f          |
| eu-west-2       | ami-0c1ffb1d6a5ed82fa    | c99157f          |
| sa-east-1       | ami-0932c29080f76d0a2    | c99157f          |
| us-east-1       | ami-0e16ecda99564e511    | c99157f          |
| us-west-1       | ami-0ee2d470a1116dda4    | c99157f          |

### Google GCP images
This table lists the currently supported GCP images for Krossboard.
During the [installation]({{< relref "/docs/deploy-for-google-gke" >}}), you can set a specific image listed in this table by setting the variable `KB_GCP_IMAGE`.

| Image                                      | Availability locations   | Build ID         |
| -------------------------------------------|:------------------------:| ----------------:|
| krossboard-v20200901t1598988567-c99157f    | Global                   | c99157f          |

### Microsoft Azure images
On Microsoft Azure, Krossboard is released though a [Shared Image Gallery](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/shared-image-galleries). 
The path of the image is: `/subscriptions/89cdfb38-415e-4612-9260-6d095914713d/resourceGroups/krossboard-release/providers/Microsoft.Compute/galleries/KrossboardRelease/images/Krossboard`.

The [setup script]({{< relref "/docs/deploy-for-azure-aks" >}}) always deploys the latest version of the image. The location of the instance, set via the variable `KB_AZURE_LOCATION`, must match one of availability locations listed in the following table.


| Image Version    | Replication regions      | Build ID         |
| -----------------|:------------------------:| ----------------:|
| /version/latest  | Brazil South             | c99157f          |
| /version/latest  | Canada Central           | c99157f          |
| /version/latest  | Central India            | c99157f          |
| /version/latest  | Central US               | c99157f          |
| /version/latest  | East US                  | c99157f          |
| /version/latest  | Germany West Central     | c99157f          |
| /version/latest  | Korea Central            | c99157f          |
| /version/latest  | UK West                  | c99157f          |
| /version/latest  | West US                  | c99157f          |
