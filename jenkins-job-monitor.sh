#!/bin/bash

MAX_MINUTE="[3-5][0-9]:|:.*:"
RUNNING_JOBS=$(ps -fU jenkins -o pid,etime,command | grep "/tmp/jenkins")

# need if condition to only send message if grep is true
if echo "$RUNNING_JOBS" | grep -E "$MAX_MINUTE" &> /dev/null; then
    curl -X POST -H 'Content-type: application/json' --data '{"text":"A job got stuck on dwh-jenkins, please check the frontend for details!"}' https://hooks.slack.com/services/my-webhook
fi
