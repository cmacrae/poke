#! /usr/bin/env bash

# Gets public IP
getIP(){
    curl -s http://icanhazip.com
}

# Get initial public IP
INIT_IP=$(getIP)

# Retain new-lines in 'NOTIFICATION'
IFS=

while sleep 60; do
    CURRENT_IP=$(getIP)
    # Poke notification configuration
    # Get the Pushover credentials from env vars
    NOTIFICATION="
---
token: ${PUSHOVER_TOKEN}
recipient: ${PUSHOVER_RECIPIENT}
title: New IP Lease
message: |
  A new public IP has been allocated
  <b>${CURRENT_IP}</b>
"

    if  [[ $INIT_IP != $CURRENT_IP ]]; then
	echo $NOTIFICATION | poke
    fi

    # Set new initial IP so we only get notificaitons on change
    export INIT_IP=$CURRENT_IP
done
