#! /usr/bin/env bash

# Use with 'consul watch' to get instant notifications on changes
# in the KV store:
# $ consul watch -type=key -key=poke_testing ./examples/monitor-kv.sh path/to/watch

KEYPATH=${1}

getKeyVal() {
    curl -s $CONSUL_HTTP_ADDR/v1/kv/${1} | \
	jq -r '.[].Value' | base64 -D
}

KEY_VAL=$(getKeyVal $1)

# Retain new-lines in 'NOTIFICATION'
IFS=
NOTIFICATION="
---
token: ${PUSHOVER_TOKEN}
recipient: ${PUSHOVER_RECIPIENT}
title: ${KEYPATH} Changed!
message: |
  <b>Looks like ${KEYPATH} changed:</b>
  ${KEY_VAL}
"

echo ${NOTIFICATION} | poke
