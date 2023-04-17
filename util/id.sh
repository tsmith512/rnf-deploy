#!/usr/bin/env bash

docker ps | grep -oP '^[0-9a-z]+(?=.+apache-\d)'

