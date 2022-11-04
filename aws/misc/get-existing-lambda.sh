#!/bin/bash

for region in `aws ec2 describe-regions --query "Regions[].RegionName" --region us-west-1 --output text`
do
  echo "$region"
  aws lambda list-functions --region ${region} --output text --query "Functions[?Runtime=='${runtime}'].{ARN:FunctionArn, Runtime:Runtime}"
done
