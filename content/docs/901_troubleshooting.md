+++
title = "Troubleshooting"
description = ""
draft = false
weight = 900
toc = true
aliases = ["/docs/troubleshooting/"]
+++

This page provides resources to troubleshoot a Krossboard deployment. 

Go to the section that describes your issue well. If the issue you're experiencing is not listed, open an issue via our [GitHub Issue Tracking Page](https://github.com/2-alchemists/krossboard/issues). Alternatively, for customers with an active support contract, you can send an email directly to our customer service: `support at krossboard.app`. 

## Krossboard UI is not reachable
Connect to the Krossboard host via SSH and check that the service is running.

```
sudo docker ps
```

A container named `krossboard-ui` should be listed. 

If there is no container with this name, restart the Krossboard UI service.

```
sudo systemctl restart krossboard-ui
```

If the container is running, check the log of the container.

```
sudo docker logs krossboard-ui
```

## All clusters do not have fresh data in the UI
If you just installed Krossboard, it may take at least 5 minutes to have first charts available. Some charts require hourly-consolidated data, hence you have need to wait about an hour to have all charts filled in.

Otherwise, check the status of Krossboard backend services as below.

First, check that all the Krossboard Data Processor systemd services are up and running.
* The API service (`krossboard-data-processor-api`).
* The Kubernetes Data Collection Service  (`krossboard-data-processor-collector`).
* The Analytics Data Consolidation Service (`krossboard-data-processor-collector`).

To check the status of a given service.

```
sudo systemctl status <service-name>
```

If a service is not running, check its logs as follows:

```
sudo journalctl -xe -u <service-name>
```

Finally, restart a service that is not running.
```
sudo systemctl restart <service-name>
```

If the problem persists, open an issue via our [GitHub Issue Tracking Page](https://github.com/2-alchemists/krossboard/issues). 

## A cluster does not have recent data in the UI
If the cluster has just been added in Krossboard, this is a normal situation. You have to wait about an hour to have all charts filled in.

Otherwise, connect to the Krossboard host via SSH and proceed as below to investigate the issue.

List the running Docker container and check that there's a `kube-opex-analytics` instance bound to the target Kubernetes cluster. 

```
docker ps
```

The name of the container shall follow the cluster name plus some extra characters automatically generated. See an example below with a GKE cluster named `cluster-1`.

```
$ docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}'
CONTAINER ID        IMAGE                                  STATUS              NAMES
d58987861c1b        rchakode/kube-opex-analytics:20.10.5   Up 18 hours         gke_dev-1-304720_us-central1-c_cluster-1-20210417T1945160700
```

Check the logs of the container to find if there were issues when collecting raw metrics from Kubernetes.

```
docker logs <container-id>
```
 