#! /usr/bin/env bash

# Target to monitor
TARGET_HOST=127.0.0.1
TARGET_PORT=3000

# Retain new-lines in 'NOTIFICATION'
IFS=

# Poke notification configuration
# Get the Pushover credentials from env vars
NOTIFICATION="
---
token: ${PUSHOVER_TOKEN}
recipient: ${PUSHOVER_RECIPIENT}
title: Service Down!
message: \"${TARGET_HOST}:${TARGET_PORT} is unreachable\"
"

while sleep 300; do
    if  [[ ! $(nc -vz $TARGET_HOST $TARGET_PORT) ]]; then
	echo $NOTIFICATION | poke
    fi
done
