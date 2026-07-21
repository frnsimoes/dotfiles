#!/bin/bash

audit_credentials() {
    for user in tintim-hetzner-prod tintim-django-prod tintim-n8n-prod; do
      echo "Audit: $user"
      aws cloudtrail lookup-events \
        --lookup-attributes AttributeKey=Username,AttributeValue=$user \
        --max-results 50 \
        --query 'Events[*].{Time:EventTime,Action:EventName,IP:SourceIPAddress}' \
        --output table
      echo ""
    done
}
