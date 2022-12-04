+++
title = "Setup Krossboard using the Kubernetes Operator"
description = ""
weight = 20
draft = false
bref = ""
toc = true
aliases = ["/docs/deploy-krossboard-using-kubernetes-operator/"]
+++

Krossboard is a multi-cluster and cross-distribution Kubernetes usage analytics and accounting software.

> Learn more about [Krossboard Features](/docs/overview-concepts-features/).

Krossboard Operator provides custom resource definitions (CRD) along with an operator to deploy and manage instances of Krossboard as Kubernetes pods.

The [Krossboard CRD](https://raw.githubusercontent.com/2-alchemists/krossboard-kubernetes-operator/main/config/releases/latest/krossboard/krossboard-kubernetes-operator.yaml) defines a Krossboard instance as a Kind, as well as parameters to bootstrap that instance: krossboard-api, krossboard-ui, krossboard-consolidator, krossboard-kubeconfig-handler, kube-opex-analytics instances.

Each instance of Krossboard enables to track the usage of a set of Kubernetes clusters listed in a KUBECONFIG secret:

* Secret Name: `krossboard-secrets`
* Secret Key: `kubeconfig`.

The next steps describe how to deploy the operator and a Krossboard instance.

## Deploy Krossboard Kubernetes Operator
The following command deploy the latest version of Krossboard Operator.

```bash
kubectl apply -f https://raw.githubusercontent.com/2-alchemists/krossboard-kubernetes-operator/main/config/releases/latest/krossboard/krossboard-kubernetes-operator.yaml
```

The installation is achieved in a namespace named `krossboard`.


## Deploy a Krossboard Instance

### <a name='CreateaKrossboardCRD'></a>Create a Krossboard CRD

Once the operator deployed, a custom resource named `Krossboard` is created. This CRD is used to define each instance of Krossboard.

See [krossboard.yaml](https://github.com/2-alchemists/krossboard-kubernetes-operator/blob/main/config/releases/latest/krossboard/krossboard.yaml) for an example of Krossboard instance definition.

Each instance of Krossboard allows to track the usage of a set of Kubernetes clusters listed in a KUBECONFIG secret (Secret Name: `krossboard-secrets`, Secret Key: `kubeconfig`). 

> A different secret can be used (instead of `krossboard-secrets`). In this case, you must set the parameter `krossboardSecretName` of the Krossboard CRD with the name of the target secret.


### Create a KUBECONFIG secret for target Kubernetes
Given a KUBECONFIG resource (`/path/to/kubeconfig` in the below command), you can create a secret for Krossboard Operator as follows. 

```bash
kubectl -n krossboard \
    create secret --type=Opaque generic krossboard-secrets \
    --from-file=kubeconfig=/path/to/kubeconfig
```

> * How to [Create a KUBECONFIG resource with minimal permissions for Krossboard](https://github.com/2-alchemists/krossboard-kubernetes-operator/blob/main/docs/create-kubeconfig-with-minimal-permissions.md).
> * How to [Create a secret from several KUBECONFIG resources](https://github.com/2-alchemists/krossboard-kubernetes-operator/blob/main/docs/create-kubeconfig-secret.md)


### Start the Krossboard Instance
The below command deploys an instance of Krossboard based on the latest version.

```bash
kubectl -n krossboard apply -f https://raw.githubusercontent.com/2-alchemists/krossboard-kubernetes-operator/main/config/releases/latest/krossboard/krossboard-deployment.yaml
```

## Day2 Operations
* [Krossboard Analytics and Data Export]({{< relref "02_analytics-and-data-export" >}})