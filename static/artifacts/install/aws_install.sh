#!/bin/bash


AWS_EC2_TYPE='t2.small'
AWS_EC2_KEY_PAIR='KrossboardTest'
AWS_EKS_REGION='eu-central-1'
KB_IMAGE='ami-0fa8675e6d205da2b'
KB_INSTANCES_INFO=$(aws ec2 run-instances --region "$AWS_REGION" --image-id "$KB_IMAGE" --instance-type "$AWS_EC2_TYPE" --key-name "$AWS_EC2_KEY_PAIR" --count 1)

ROLE_NAME='krossboard-role'
wget -O /tmp/${ROLE_NAME}-policy.json https://krossboard.app/artifacts/aws/krossboard-role-policy.json
wget -O /tmp/${ROLE_NAME}-trust-policy.json https://krossboard.app/artifacts/aws/krossboard-role-trust-policy.json
KB_POLICY=$(aws iam create-policy --policy-name krossboard-policy --policy-document file:///tmp/${ROLE_NAME}-policy.json)
KB_ROLE=$(aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file:///tmp/${ROLE_NAME}-trust-policy.json)
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$(echo $KB_POLICY | jq -r '.Policy.Arn')"
aws iam create-instance-profile --instance-profile-name "${ROLE_NAME}-profile"
aws iam add-role-to-instance-profile --role-name "$ROLE_NAME" --instance-profile-name "${ROLE_NAME}-profile"
# The role profile or the instance may not be ready immediately.
# That's why the next command that assigned the profile to the instance
# is retried a couple of times.
n=0
until [ "$n" -ge 15 ]
do
   aws ec2 associate-iam-instance-profile --instance-id "$(echo $KB_INSTANCES_INFO | jq -r '.Instances[0].InstanceId')" --iam-instance-profile Name="${ROLE_NAME}-profile" && break
   n=$((n+1)) 
   sleep 1
done

echo -e "\e[1m\e[32m=== Summary the Krossboard instance ==="
echo -e "Instance ID => `echo $KB_ROLE | jq -r '.Role.Arn'`"
echo -e "ARN => => `echo $KB_ROLE | jq -r '.Role.Arn'`"
echo -e "===========================================\e[0m"
