#!/bin/bash

#set -x

export AWS_PAGER=""


while [ $# -gt 0 ]; do
  case "$1" in
    -h|--hosted-zone-domain)
      hosted_zone_domain="$2"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
  shift
done


aws acm request-certificate --domain-name "$hosted_zone_domain" --validation-method DNS | jq '.CertificateArn'

cert_arn=$(aws acm list-certificates | jq -c --arg domain "$hosted_zone_domain" '.CertificateSummaryList[] | select(.DomainName == $domain)'| jq -r '.CertificateArn')


# Need to sleep here
sleep 5

cert_desc=$(aws acm describe-certificate --certificate-arn "$cert_arn")

output_txt_file_dns_record="./data-tmp-dns-record.txt"
echo > "$output_txt_file_dns_record"


echo "$cert_desc" > "$output_json_file_cert_desc"
read Name Type Value < <(echo $(echo "$cert_desc" | jq -r '.Certificate.DomainValidationOptions[] | .ResourceRecord | .Name, .Type, .Value'))

echo "$Name"  >> "$output_txt_file_dns_record"
echo "$Type"  >> "$output_txt_file_dns_record"
echo "$Value" >> "$output_txt_file_dns_record"
