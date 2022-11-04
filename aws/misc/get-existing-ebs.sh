#!/bin/bash

for region in `aws ec2 describe-regions --query "Regions[].RegionName" --region us-west-1 --output text`
do
  echo "$region"
  aws ec2 describe-snapshots --owner-ids self  --query 'Snapshots[]' --region="$region"
done
