#!/usr/bin/env bash

### --- CONFIGURATION --- ###
CF_API_TOKEN="YOUR_CLOUDFLARE_TOKEN"
CF_ZONE_ID="YOUR_ZONE_ID"

# List of DNS records to update (A records)
# true for proxied.
RECORDS=(
    "domain.com true"
    "first.domain.com true"
    "last.domain.com false"
)

IP_FILE="/tmp/cf_ip.txt"
CURRENT_IP=$(curl -s https://ifconfig.me)

# Exit if no IP detected
if [[ -z "$CURRENT_IP" ]]; then
    echo "Could not detect public IP"
    exit 1
fi

# Exit if IP hasn't changed
if [[ -f "$IP_FILE" ]]; then
    OLD_IP=$(cat "$IP_FILE")
    if [[ "$CURRENT_IP" == "$OLD_IP" ]]; then
        exit 0
    fi
fi

echo "IP changed to $CURRENT_IP — updating Cloudflare..."

### --- UPDATE EACH RECORD --- ###
for ENTRY in "${RECORDS[@]}"; do
    RECORD_NAME=$(echo "$ENTRY" | awk '{print $1}')
    PROXIED=$(echo "$ENTRY" | awk '{print $2}')

    # Fetch record ID
    RECORD_INFO=$(curl -s -X GET \
        "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?type=A&name=$RECORD_NAME" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json")

    RECORD_ID=$(echo "$RECORD_INFO" | grep -oP '"id":"\K[^"]+')

    if [[ -z "$RECORD_ID" ]]; then
        echo "Could not find record: $RECORD_NAME"
        continue
    fi

    # Update DNS record
    UPDATE=$(curl -s -X PUT \
        "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":$PROXIED}")

    if echo "$UPDATE" | grep -q '"success":true'; then
        echo "Updated $RECORD_NAME → $CURRENT_IP (proxied: $PROXIED)"
    else
        echo "Failed to update $RECORD_NAME"
        echo "$UPDATE"
    fi
done

echo "$CURRENT_IP" > "$IP_FILE"
