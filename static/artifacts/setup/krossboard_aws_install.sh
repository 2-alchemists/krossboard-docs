#!/bin/bash
# ------------------------------------------------------------------------ #
# File: krossboard_aws_install.sh                                          #
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

echo "==> Checking deployment parameters..."
curl -so krossboard_default.sh https://krossboard.app/artifacts/setup/krossboard_default.sh && \
  source ./krossboard_default.sh

if [ -z "$KB_AWS_KEY_PAIR" ]; then
  echo -e "\e[31mPlease set the KB_AWS_KEY_PAIR variable with the EC2 key pair to use\e[0m"
  exit 1
fi

if [ -z "$KB_AWS_AMI" ]; then
  KB_AWS_AMI="$KB_AWS_AMI_DEFAULT" 
  echo -e "\e[35mKB_AWS_AMI not set, using => $KB_AWS_AMI\e[0m"
fi

if [ -z "$KB_AWS_INSTANCE_TYPE" ]; then
  KB_AWS_INSTANCE_TYPE="t2.small" 
  echo -e "\e[35mAWS_EC2_TYPE not set, using => $KB_AWS_INSTANCE_TYPE\e[0m"
fi

if [ -z "$KB_AWS_REGION" ]; then
  if [ -z "$AWS_DEFAULT_REGION" ]; then
      echo -e "\e[31mPlease set either KB_AWS_REGION or AWS_DEFAULT_REGION variable\e[0m"
    exit 1
  fi
  KB_AWS_REGION="$AWS_DEFAULT_REGION" 
  echo -e "\e[35mKB_REGION not set, using => $KB_AWS_REGION (AWS_DEFAULT_REGION)\e[0m"
fi

echo -e "\e[32m==> Summary of installation settings:\e[0m"
echo "    KB_AWS_KEY_PAIR => $KB_AWS_KEY_PAIR"
echo "    KB_AWS_INSTANCE_TYPE => $KB_AWS_INSTANCE_TYPE"
echo "    KB_AWS_REGION => $KB_AWS_REGION"

while true; do
    echo -e '\e[32mProceed with the installation? y/n\e[0m'
    read yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# now only accept bound variables
set -u

echo "==> Start a Krossboard instance..."
KB_INSTANCES_INFO=$(aws ec2 run-instances \
   --region "$KB_AWS_REGION" \
   --image-id "$KB_AWS_AMI" \
   --instance-type "$KB_AWS_INSTANCE_TYPE" \
   --key-name "$KB_AWS_KEY_PAIR" \
   --count 1)


echo "==> Configure IAM permissions for the Krossboard instance..."
KB_TIMESTAMP=`date +%F-%s`
KB_ROLE_NAME="krossboard-role-$KB_TIMESTAMP"
wget -O /tmp/${KB_ROLE_NAME}-policy.json https://krossboard.app/artifacts/aws/krossboard-role-policy.json
wget -O /tmp/${KB_ROLE_NAME}-trust-policy.json https://krossboard.app/artifacts/aws/krossboard-role-trust-policy.json
KB_POLICY=$(aws iam create-policy --policy-name ${KB_ROLE_NAME}-policy --policy-document file:///tmp/${KB_ROLE_NAME}-policy.json)
KB_ROLE=$(aws iam create-role --role-name "$KB_ROLE_NAME" --assume-role-policy-document file:///tmp/${KB_ROLE_NAME}-trust-policy.json)
aws iam attach-role-policy --role-name "$KB_ROLE_NAME" --policy-arn "$(echo $KB_POLICY | jq -r '.Policy.Arn')"
aws iam create-instance-profile --instance-profile-name "${KB_ROLE_NAME}-profile"
aws iam add-role-to-instance-profile --role-name "$KB_ROLE_NAME" --instance-profile-name "${KB_ROLE_NAME}-profile"
# The role profile or the instance may not be ready immediately.
# That's why the next command that assigned the profile to the instance
# is retried a couple of times.
n=0
until [ "$n" -ge 15 ]
do
   aws ec2 associate-iam-instance-profile --instance-id "$(echo $KB_INSTANCES_INFO | jq -r '.Instances[0].InstanceId')" --iam-instance-profile Name="${KB_ROLE_NAME}-profile" && break
   n=$((n+1))
   echo -e "\e[35mRetrying to associate instance profile...\e[0m"
   sleep 1
done

echo "==> Generating RBAC permissions to enable access to metrics..."
cat << EOF > /tmp/kb-aws-rbac-settings.yml
      - krossboard-data-processor
      rolearn: KB_ROLE_ARN
      username: KB_ROLE_ARN
EOF
KB_ROLE_ARN=$(echo $KB_ROLE | jq -r '.Role.Arn')
sed -i 's!KB_ROLE_ARN!'$KB_ROLE_ARN'!' /tmp/kb-aws-rbac-settings.yml

CURRENT_CLUSTERS=$(aws eks list-clusters --region eu-central-1 | jq  -r '.clusters[]')
for cluster in $CURRENT_CLUSTERS; do
    aws eks update-kubeconfig --name $cluster --region $KB_AWS_REGION
    
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
      kubectl -nkube-system get deploy metrics-server*
    else
      echo -e "\e[35mA metrics server is already deployed in kube-system namespace\e[0m"
    fi

    echo "==> Updating EKS RBAC settings to enable read access to metrics..."
    echo -e "\e[35mBacking up AWS existing RBAC settings...\e[0m"
    AWS_AUTH_CM_BACKUP=aws-auth-backup-${cluster}-$(date +%F-%s).yaml
    kubectl -n kube-system get configmap aws-auth -o yaml > $AWS_AUTH_CM_BACKUP
    ls -l $AWS_AUTH_CM_BACKUP
    echo -e "\e[35mApplying RBAC settings...\e[0m"
    sed '/- groups:/r /tmp/kb-aws-rbac-settings.yml' $AWS_AUTH_CM_BACKUP | kubectl apply -f -
    kubectl create -f https://krossboard.app/artifacts/k8s/clusterrolebinding-eks.yml || \
      kubectl apply -f https://krossboard.app/artifacts/k8s/clusterrolebinding-eks.yml
done

echo -e "\e[1m\e[32m=== Summary the Krossboard instance ==="
echo -e "Instance ID => `echo $KB_INSTANCES_INFO | jq -r '.Instances[0].InstanceId'`"
echo -e "Region => $KB_AWS_REGION"
echo -e "Key Pair => $KB_AWS_KEY_PAIR"
echo -e "===========================================\e[0m"