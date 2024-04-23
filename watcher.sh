#!/bin/bash

NAMESPACE="sre"
DEPLOYMENT="swype-app"

MAX_RESTARTS=4

while true; do 
    RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT} -o jsonpath="{.items[0]}.status.containerStatuses[0].restartCount"})

    echo "Current no. of restarts: ${RESTARTS}"

    if (( RESTARTS > MAX_RESTARTS )); then 
        echo "Max number of restarts hit, scaling down deployment"
        kubectl scale --replicas=0 deployment/${DEPLOYMENT} -n ${NAMESPACE}
        break
    fi

    sleep 60
done