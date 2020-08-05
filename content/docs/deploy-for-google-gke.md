+++
title = "Setup Krossboard for Google GKE"
description = ""
weight = 30
draft = false
bref = ""
toc = true 
+++

On Google Compute Platform (GCP), Krossboard works as a standalone Compute Engine instance.
Each instance discovers and handles GKE clusters on a per [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) basis. 

This guide describes step-by-step how to deploy and configure an instance of Krossboard for a GCP project. 

## Before you begin
This guide should be straightforward to follow, assuming that:

* You have a basic level of practice with GCP concepts.
* You have access to [Google Cloud Console](https://console.cloud.google.com/).
* You have access to a GCP project with sufficient permissions to:
  * Create a [GCP service account](https://cloud.google.com/iam/docs/understanding-service-accounts) for Krossboard.
  * Assign GCP predefined roles to a GCP service account.
  * Use Google Cloud Console, though the steps can be adapted for a scripted/automated deployment.

> Note that all the below steps are achieved from the Google Cloud Console.

## Step 1: Select a GCP project
Krossboard discovers and handles GKE clusters as a project basics. The clusters can be spread accross different regions and zones in that project.

 On the Cloud Console, select a project as follows.

 ![](/images/docs/gcp-select-project.png)


## Step 2: Create an IAM service account for Krossboard
Each Krossboard instance needs to have a the role of **Kubernetes Engine Viewer** (i.e. read-only access to GKE resources).
This role is assigned to it through a service account created as below on the Google Cloud Console.

* On the Navigation menu (![GCP Navigation Menu](/images/docs/gcp-nagivation-menu.png)), select **IAM & Admin -> Service accounts**.
* Click **Create Service Account**.
* Name the **Service account** and (optionally) provide a description.
* Click **Create** to move forward.
* In the **permissions** section, assign to the service account the role of **Kubernetes Engine Viewer**.
* Click **Continue**.
* Click **Done** to complete the service account creation.

> Copy the email address of the service account just created, it'll be needed in the next section.

## Step 3: Deploy a Krossboard instance

This section requires to have access to Cloud Shell or a terminal with gcloud installed and configured with sufficiant credentials to create a compute instance.

First review and set the following variables in your terminal: 
  * Set the variable `KB_IMAGE` with a valid Krossboard image.
  * Variables starting `GCP_`  to ensure that it corresponds your target environments. In particular, the variable `GCP_SERVICE_ACCOUNT_EMAIL` shall match the email of the service account created above.

```bash
KB_IMAGE="krossboard-beta-v20200726t1595767620"
GCP_PROJECT="my-gke-project"
GCP_ZONE="us-central1-a"
GCP_INSTANCE_TYPE="g1-small"  
GCP_SERVICE_ACCOUNT_EMAIL="krossboard@krossboard-test.iam.gserviceaccount.com"
```

> **Note:** A `g1-small` instance is a good starting point, unless you have 10+ GKE clusters with many namespaces in the same project. Either way, think to regularly check the metrics of the instance to adapt your choice if applicable.


Then start your instance of Krossboard.

```bash
gcloud compute instances create ${KB_IMAGE} \
      --scopes=https://www.googleapis.com/auth/cloud-platform \
      --project=${GCP_PROJECT} \
      --zone=${GCP_ZONE} \
      --machine-type=${GCP_INSTANCE_TYPE} \
      --service-account=${GCP_SERVICE_ACCOUNT_EMAIL} \
      --image=${KB_IMAGE} \
      --image-project=krossboard-factory \
      --tags=krossboard-server
```

> if prompted, answer `y`es to enable Compute Engine API.

Enable the acces to the Krossbord web interface

```bash
gcloud compute firewall-rules create krossboard-allow-http \
    --project=${GCP_PROJECT} \
    --direction=INGRESS \
    --priority=1000 --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=krossboard-server
```


## Step 4: Get Access to Krossboard UI
Go to the GCP console to get the IP address of the instance. 

Then open a browser tab and point it to this URL `http://KROSSBOARD_IP/`, changing `KROSSBOARD_IP` to the IP address of the Krossboard instance.

Here are credentials to log in:

* **Username:** krossboard
* **Password (default):** Kr0sSB8qrdAdm

> It's highly recommended to change this default password as soon as possible. 
> ```bash
> sudo /opt/krossboard/bin/krossboard-change-passwd
> ```

## Next Steps
* Exploring the [Analytics User Interface]({{< relref "/docs/analytics-reports-and-data-export" >}})
* Other [documentation resources]({{< relref "/docs" >}}).