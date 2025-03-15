#!/bin/sh

# Manually replace environment variables in the template file
sed -e "s|\${TROJAN_REMOTE_ADDR}|$TROJAN_REMOTE_ADDR|g" \
    -e "s|\${TROJAN_REMOTE_PORT}|$TROJAN_REMOTE_PORT|g" \
    -e "s|\${TROJAN_PASSWORD}|$TROJAN_PASSWORD|g" \
    /config/config.json.template > /config/config.json

# Start trojan with the generated config
exec /usr/local/bin/trojan /config/config.json 