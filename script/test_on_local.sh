#!/usr/bin/env bash

redis-server &
sleep 3
redis-cli flushdb
grunt test
pkill redis-server