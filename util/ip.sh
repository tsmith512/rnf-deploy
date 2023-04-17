#!/usr/bin/env bash

docker network inspect route-not-found | jq -r 'map(.Containers[] | .Name + " " + .IPv4Address) []' | grep -oP '(?<='"$1"'-\d ).+(\d{1,3}\.?){4}'
