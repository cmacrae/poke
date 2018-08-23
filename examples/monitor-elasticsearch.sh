#! /usr/bin/env bash

# Get the Elasticsearch master from Consul
ES_MASTER=http://$(curl -s "https://${CONSUL_HTTP_ADDR}/v1/catalog/service/elasticsearch?tag=master" | \
		       jq -r '.[] | "\(.ServiceAddress):\(.ServicePort)"')

# Retain new-lines in 'NOTIFICATION'
IFS=


while sleep 30; do
    HEALTH=$(curl -s $ES_MASTER/_cluster/health)
    STATUS=$(echo $HEALTH | jq -rM '.status')
    UA_SHARDS=$(echo $HEALTH | jq -rM '.unassigned_shards')
    PENDING=$(echo $HEALTH | jq -rM '.number_of_pending_tasks')

    # Poke notification configuration
    # Get the Pushover credentials from env vars
    NOTIFICATION="
---
token: ${PUSHOVER_TOKEN}
recipient: ${PUSHOVER_RECIPIENT}
title: Elastic health degraded
message: |
  <b>Status</b> <font color=\"#FF8552\">${STATUS}</font>
  <b>Unassigned Shards</b> ${UA_SHARDS}
  <b>Pending Tasks</b> ${PENDING}
"
    if  [[ $STATUS != "green" ]]; then
	echo $NOTIFICATION | poke
    fi
done
