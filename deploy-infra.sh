#!/bin/bash

# We’ll use the AWS CLI to submit infrastructure updates to CloudFormation.
# Although we could interact with CloudFormation directly from the AWS CLI,
# it is easier to write a script containing the necessary parameters.


# A stack is what CloudFormation calls the collection of
# resources that are managed together as a unit.
STACK_NAME=awsbootstrap

# The region to deploy to.
REGION=eu-west-3
CLI_PROFILE=default

# An instance type in the free tier.
EC2_INSTANCE_TYPE=t2.micro

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    EC2InstanceType=$EC2_INSTANCE_TYPE

# If the deploy succeeded, show the DNS name of the created instance
echo -e "\n\n=========== Prints Instance Endpoint ==========="
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile default \
    --query "Exports[?Name=='InstanceEndpoint'].Value"
fi
