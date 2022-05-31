
#!/usr/bin/env bash

export AWS_PAGER=""

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--hosted-zone-domain)
      hosted_zone_domain="$2"
      ;;
    -s|--sub-domain)
      sub_domain="$2"
      ;;
    -t|--record-type)
      record_type="$2"
      ;;
    -v|--value)
      value="$2"
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

echo "Find hosted zone id for $hosted_zone_domain..."
hosted_zone_id=$(aws route53 list-hosted-zones | jq -c --arg domain "$hosted_zone_domain"  '.HostedZones[] | select(.Name == $domain)' | jq -r '.Id' | cut -d"/" -f3)

echo "Hosted zone id for $hosted_zone_domain is: $hosted_zone_id"

echo "Create a record with type $record_type for the sub domain $sub_domain with value $value ..."

aws route53 change-resource-record-sets --hosted-zone-id "$hosted_zone_id"  --change-batch file://<(cat << EOF
{
  "Comment": "Testing creating a record set",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$sub_domain",
        "Type": "$record_type",
        "TTL": 120,
        "ResourceRecords": [
          {
            "Value": "$value"
          }
        ]
      }
    }
  ]
}
EOF
)

echo "Done!"

#TODO: Testing the new record using tool like dig, ...
