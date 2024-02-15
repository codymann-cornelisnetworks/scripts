#! /usr/bin/env bash

while true
do
    free
    if [[ $? -ne 0 ]]
    then
        echo "command failed"
        break
    fi
    sleep 10
done
