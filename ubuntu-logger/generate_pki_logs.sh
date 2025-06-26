#!/bin/bash
PKI_DNS=(
  "CN=dev-app01,OU=DEV,O=Google"
  "CN=dev-db01,OU=DEV,O=Google"
  "CN=dev-web01,OU=DEV,O=Google"
  "CN=test-app01,OU=TEST,O=Microsoft"
  "CN=test-db01,OU=TEST,O=Microsoft"
  "CN=test-web01,OU=TEST,O=Microsoft"
  "CN=prod-app01,OU=PROD,O=Amazon"
  "CN=prod-db01,OU=PROD,O=Amazon"
  "CN=prod-web01,OU=PROD,O=Amazon"
  "CN=prod-batch01,OU=PROD,O=Amazon"
)

while true; do
  R=$((RANDOM % 10))
  if [ $R -lt 7 ]; then
    DN=${PKI_DNS[$((RANDOM % 10))]}
    logger "System is using $DN for authentication purpose."
  elif [ $R -eq 7 ]; then
    logger "Random event: System maintenance in progress."
  fi
  sleep 1
done
