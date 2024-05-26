#!/bin/bash

while true; do
  TRUSTED_STATUS=$(curl -s http://localhost:26657/status)
  STATUS=$(curl -s http://localhost:26657/status)
  HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:26657/health)
  NET_INFO=$(curl -s http://localhost:26657/net_info)

  if [ "$HEALTH" -eq 200 ]; then
    HEALTH_STATUS=1
  else
    HEALTH_STATUS=0
  fi

  echo "# HELP validator_status Validator status metrics
# TYPE validator_status gauge
validator_latest_block_height $(echo $STATUS | jq -r '.result.sync_info.latest_block_height')
validator_catching_up $(echo $STATUS | jq -r '.result.sync_info.catching_up')
validator_voting_power $(echo $STATUS | jq -r '.result.validator_info.voting_power')

# HELP trusted_validator_status Validator status metrics (A valid Validator's metrics, for comparison)
# TYPE trusted_validator_status gauge
trusted_validator_latest_block_height $(echo $TRUSTED_STATUS | jq -r '.result.sync_info.latest_block_height')
trusted_validator_catching_up $(echo $TRUSTED_STATUS | jq -r '.result.sync_info.catching_up')

# HELP validator_health Validator health metrics
# TYPE validator_health gauge
validator_health $HEALTH_STATUS

# HELP validator_peer_count Number of connected peers
# TYPE validator_peer_count gauge
validator_peer_count $(echo $NET_INFO | jq -r '.result.n_peers')
" > /var/lib/prometheus/metrics/validator_metrics.prom
done
