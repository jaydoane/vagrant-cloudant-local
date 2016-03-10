#!/bin/bash -e

until $(curl --output /dev/null --silent --head --fail http://localhost:5984); do
    printf '.'
    sleep 1
done
