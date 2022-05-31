#!/bin/bash

curl -s "https://raw.githubusercontent.com/sexydevops/useful-scripts/main/aws/acm/request-certificates-for-a-domain.sh" | bash -s -- --hosted-zone-domain "*.api.devops.ci"

read Name Type Value < <(echo $(cat "./data-tmp-dns-record.txt"))

curl -s "https://raw.githubusercontent.com/sexydevops/useful-scripts/main/aws/route53/upsert-a-record.sh" | bash -s -- --hosted-zone-domain "api.devops.ci" --sub-domain "$Name" --record-type "$Type" --value "$Value"


rm -rf "./data-tmp-dns-record.txt"
