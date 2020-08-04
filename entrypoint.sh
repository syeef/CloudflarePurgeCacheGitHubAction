#!/bin/bash

set -e

#Check if Auth Key is supplied
if [-z "$CLOUDFLARE_AUTH_KEY" ]; then
    echo "❌ Cloudflare Auth Key is required to proceed."
    exit 1
fi

#Check if Zone ID is supplied
if [-z "$CLOUDFLARE_ZONE_ID" ]; then
    echo "❌ Cloudflare Zone ID is required to proceed."
    exit 1
fi

#Determine between purging a specific file(s) or purging everything
if [-z "$PURGE_FILES"]; then
    $data='{"purge_everything":true}'
else
    $data='{"files":'"$PURGE_FILES"'}'
fi

#Response
HTTP_RESPONSE=$(curl -X POST "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/purge_cache" \
     -H "Content-Type:application/json" \
     -H "Authorization: Bearer $CLOUDFLARE_AUTH_KEY" \
     -- data $data)

HTTP_BODY=$(echo $HTTP_RESPONSE | sed -E 's/HTTPSTATUS\:[0-9]{3}$//')
HTTP_STATUS=$(echo $HTTP_RESPONSE | tr -d '\n' | sed -E 's/.*HTTPSTATUS:([0-9]{3})$/\1/'

if [ "${HTTP_STATUS}" -eq "200" ]; then
  echo "✅ Cloudflare successfully purged."
  exit 0
else
  echo "❌ Purge failed. "
  echo "${HTTP_BODY}"
  exit 1
fi
