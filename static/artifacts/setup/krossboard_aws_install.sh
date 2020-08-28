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
curl -so /tmp/krossboard_default.sh https://krossboard.app/artifacts/setup/krossboard_default.sh && \
  source /tmp/krossboard_default.sh

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

echo -e "\e[32m==> Installation settings:\e[0m"
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

echo "==> Configure IAM permissions for the Krossboard instance..."
KB_TIMESTAMP=`date +%F-%s`

KB_ROLE_NAME="krossboard-role"
KB_ROLE_ARN="UNDEFINED"
KB_ROLE_PROFILE_FOUND=$(aws iam get-instance-profile --instance-profile-name "$KB_ROLE_NAME" || echo "KB_ROLE_PROFILE_NOT_FOUND")
if [ "$KB_ROLE_PROFILE_FOUND" == "KB_ROLE_PROFILE_NOT_FOUND" ]; then
  echo -e "\e[35mRole of ${KB_ROLE_NAME} does not exist, creating it...\e[0m"
  wget -O /tmp/${KB_ROLE_NAME}-policy.json https://krossboard.app/artifacts/setup/aws/krossboard-role-policy.json
  wget -O /tmp/${KB_ROLE_NAME}-trust-policy.json https://krossboard.app/artifacts/setup/aws/krossboard-role-trust-policy.json
  KB_ROLE_ARN=$(aws iam create-role --role-name "$KB_ROLE_NAME" --assume-role-policy-document file:///tmp/${KB_ROLE_NAME}-trust-policy.json -query "Role.Arn" --output=text)
  aws iam put-role-policy --role-name "$KB_ROLE_NAME" --policy-name "${KB_ROLE_NAME}-policy" --policy-document file:///tmp/${KB_ROLE_NAME}-policy.json
  KB_ROLE_PROFILE=$(aws iam create-instance-profile --instance-profile-name "${KB_ROLE_NAME}")
  aws iam add-role-to-instance-profile --role-name "$KB_ROLE_NAME" --instance-profile-name "${KB_ROLE_NAME}"
else
  KB_ROLE_ARN=$(aws iam get-role --role-name "$KB_ROLE_NAME" --query="Role.Arn" --output=text)
  echo -e "\e[35mUsing role ${KB_ROLE_NAME} ==> $KB_ROLE_ARN\e[0m"
fi

echo "==> Creating security group with HTTP ingress enabled..."
KB_SG_NAME="krossboard-sg"
KB_SG_ID=$(aws ec2 describe-security-groups --group-names "$KB_SG_NAME" --query "SecurityGroups[*].GroupId" --output=text || echo "KB_SG_NOT_FOUND")
if [ "$KB_SG_ID" == "KB_SG_NOT_FOUND" ]; then
  KB_SG_ID=$(aws ec2 create-security-group --group-name "$KB_SG_NAME" --description "SG for Krossboard instances" --query "GroupId" --output=text)
  aws ec2 authorize-security-group-ingress --group-name $KB_SG_NAME --protocol tcp --port 80 --cidr '0.0.0.0/0'
fi

echo "==> Starting a Krossboard instance..."
KB_INSTANCE_NAME="krossboard-$KB_TIMESTAMP"

KB_INSTANCES_INFO=$(aws ec2 run-instances \
   --region "$KB_AWS_REGION" \
   --image-id "$KB_AWS_AMI" \
   --instance-type "$KB_AWS_INSTANCE_TYPE" \
   --key-name "$KB_AWS_KEY_PAIR" \
   --security-group-ids "$KB_SG_ID" \
   --count 1)
KB_INSTANCE_ID=$(echo $KB_INSTANCES_INFO | jq -r '.Instances[0].InstanceId')

# The role profile or the instance may not be ready immediately.
# That's why the next command that assigned the profile to the instance
# is retried a couple of times.
n=0
until [ "$n" -ge 15 ]
do
   KB_ASSOCIATED_PROFILE=$(aws ec2 associate-iam-instance-profile \
    --instance-id $KB_INSTANCE_ID \
    --iam-instance-profile Name=${KB_ROLE_NAME}) && break
   n=$((n+1))
   echo -e "\e[35mRetrying to associate role profile...\e[0m"
   sleep 1
done

echo "==> Configuring required RBAC permissions to retrieve EKS metrics..."
curl -so krossboard_aws_configure_new_clusters.sh https://krossboard.app/artifacts/setup/krossboard_aws_configure_new_clusters.sh && \
  source ./krossboard_aws_configure_new_clusters.sh "$KB_ROLE_ARN" "$KB_AWS_REGION"

echo "==> Tagging the instance..."
aws ec2 create-tags --resources "$KB_INSTANCE_ID" --tags Key=Name,Value="$KB_INSTANCE_NAME" --region "$KB_AWS_REGION"

echo "==> Retrieving instance public IP..."
KB_IP=$(aws ec2 describe-instances --instance-ids $KB_INSTANCE_ID --query "Reservations[*].Instances[*].PublicIpAddress" --output=text)

echo -e "\e[1m\e[32m=== Summary the Krossboard instance ==="
echo -e "Instance Name => $KB_INSTANCE_NAME"
echo -e "Instance ID => $KB_INSTANCE_ID"
echo -e "Region => $KB_AWS_REGION"
echo -e "Key Pair => $KB_AWS_KEY_PAIR"
echo -e "Krossboard UI => http://$KB_IP/"
echo -e "\e[0m"