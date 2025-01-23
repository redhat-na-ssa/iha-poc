#!/bin/bash

export HOST=$(oc get route sample-rest-api -n island-ci-cd-poc -o jsonpath='{.spec.host}')
echo $HOST

# Set the API URL
URL="https://${HOST}/hello"

# Number of concurrent requests
CONCURRENT_REQUESTS=100

# Number of total requests
TOTAL_REQUESTS=10000

# Function to send a single request
send_request() {
  curl -s -o /dev/null -w "%{http_code}\n" -X GET "$URL" -H "accept: application/json"
}

# Launch requests in parallel
echo "Starting stress test with $CONCURRENT_REQUESTS concurrent requests, $TOTAL_REQUESTS total requests..."
for ((i=0; i<TOTAL_REQUESTS; i++)); do
  send_request &  # Run each request in the background
  # Limit concurrent requests
  if (( i % CONCURRENT_REQUESTS == 0 )); then
    wait  # Wait for all background processes to complete
  fi
done

# Wait for any remaining background processes
wait
echo "Stress test completed."
