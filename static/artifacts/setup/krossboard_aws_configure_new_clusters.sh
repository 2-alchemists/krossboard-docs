#!/bin/bash
# ------------------------------------------------------------------------ #
# File: krossboard_aws_add_new_clusters.sh                                 #
# Creation: August 22, 2020                                                #
# Copyright (c) 2020 2Alchemists SAS                                       #
#                                                                          #
# This file is part of Krossboard (https://krossboard.app/).               #
#                                                                          #
# The tool is distributed in the hope that it will be useful,              #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# Krossboard terms of use: https://krossboard.app/legal/terms-of-use/      #
#--------------------------------------------------------------------------#

set -e
set -u

if [ $# -ne 2 ]; then
  echo "usage: "
  echo "`basename $0` <krossbboard-role-arn> <aws-region>"
  exit 1
fi

KB_ROLE_ARN=$1
KB_AWS_REGION=$2

echo "==> Generating RBAC permissions to enable access to metrics..."
cat << EOF > /tmp/kb-aws-rbac-settings.yml
    - groups:
      - krossboard-data-processor
      rolearn: KB_ROLE_ARN
      username: KB_ROLE_ARN
EOF
cat << EOF > /tmp/kb-aws-rbac-settings-no-group.yml
      rolearn: KB_ROLE_ARN
      username: KB_ROLE_ARN
EOF
sed -i 's!KB_ROLE_ARN!'$KB_ROLE_ARN'!' /tmp/kb-aws-rbac-settings-no-group.yml
sed -i 's!KB_ROLE_ARN!'$KB_ROLE_ARN'!' /tmp/kb-aws-rbac-settings.yml

CURRENT_CLUSTERS=$(aws eks list-clusters --region $KB_AWS_REGION | jq  -r '.clusters[]')
for cluster in $CURRENT_CLUSTERS; do
    # aws eks update-kubeconfig --name $cluster --region $KB_AWS_REGION
    echo "==> Check if metrics server is installed..."
    METRIC_SERVER_FOUND=$(kubectl -nkube-system get deploy metrics-server || echo "NO_METRIC_SERVER")
    if [ "$METRIC_SERVER_FOUND" == "NO_METRIC_SERVER" ]; then
      echo -e "\e[35mA installing metrics server on cluster $cluster...\e[0m"
      METRIC_SERVER_VERSION=v0.3.6
      DOWNLOAD_URL=https://api.github.com/repos/kubernetes-sigs/metrics-server/tarball/${METRIC_SERVER_VERSION}
      curl -Ls $DOWNLOAD_URL -o metrics-server-$METRIC_SERVER_VERSION.tar.gz
      mkdir -p metrics-server-$METRIC_SERVER_VERSION
      tar -xzf metrics-server-$METRIC_SERVER_VERSION.tar.gz --directory metrics-server-$METRIC_SERVER_VERSION --strip-components 1
      kubectl apply -f metrics-server-$METRIC_SERVER_VERSION/deploy/1.8+/
      kubectl -nkube-system get deploy metrics-server
    else
      echo -e "\e[35mA metrics server is already deployed in kube-system namespace\e[0m"
    fi

    echo "==> Updating EKS RBAC settings to enable read access to metrics..."
    kubectl create -f https://krossboard.app/artifacts/setup/k8s/clusterrolebinding-eks.yml || \
      kubectl apply -f https://krossboard.app/artifacts/setup/k8s/clusterrolebinding-eks.yml
      
    echo -e "\e[35mBacking up aws-auth and updating it to set RBAC group...\e[0m"
    AWS_AUTH_CM_BACKUP=aws-auth-backup-${cluster}-$(date +%F-%s).yaml
    kubectl -n kube-system get configmap aws-auth -o yaml > $AWS_AUTH_CM_BACKUP
    ls -l $AWS_AUTH_CM_BACKUP

    KB_GROUP_FOUND=$(grep '^[[:space:]]*\- krossboard-data-processor' $AWS_AUTH_CM_BACKUP | wc -l)
    if [ $KB_GROUP_FOUND -eq 0 ]; then
      echo -e "\e[35mApplying RBAC settings...\e[0m"
      sed '/mapRoles: |/r /tmp/kb-aws-rbac-settings.yml' $AWS_AUTH_CM_BACKUP | kubectl apply -f -
    else
      KB_ROLE_FOUND=$(grep "$KB_ROLE_ARN" $AWS_AUTH_CM_BACKUP | wc -l)
      if [ $KB_ROLE_FOUND -eq 0 ]; then
        echo -e "\e[35mApplying RBAC settings...\e[0m"
        sed '/- krossboard-data-processor/r /tmp/kb-aws-rbac-settings-no-group.yml' $AWS_AUTH_CM_BACKUP | kubectl apply -f -
      else
        echo -e "\e[35mThe role $KB_ROLE_ARN seems to be already bound.\e[0m"
      fi
    fi
done