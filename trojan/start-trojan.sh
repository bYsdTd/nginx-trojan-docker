#!/bin/sh

# Replace environment variables in the template file
envsubst < /config/config.json.template > /config/config.json

# Start trojan with the generated config
exec /usr/local/bin/trojan /config/config.json 