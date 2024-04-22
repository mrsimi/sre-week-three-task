#!/bin/bash

# Define Variables
namespace="sre"
deployment="swype-app"
max_restarts=3

# Start Infinite Loop
while true; do
    # Check Pod Restarts
    restarts=$(kubectl get pods -n $namespace --selector=app=$deployment -o jsonpath='{.items[0].status.containerStatuses[0].restartCount}')

    # Display Restart Count
    echo "Current restarts: $restarts"

    # Check Restart Limit
    if [ $restarts -gt $max_restarts ]; then
        # Scale Down if Necessary
        echo "Exceeded maximum restarts. Scaling down deployment."
        kubectl scale deployment $deployment -n $namespace --replicas=0
        break
    fi

    # Pause for 60 seconds
    sleep 60
done
