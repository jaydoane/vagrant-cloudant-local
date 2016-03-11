#!/bin/bash

DB_PREFIX=${DB_PREFIX-db}

for host in `grep ${DB_PREFIX}[0-9]*[0-9a-z.] /etc/hosts | awk '{ print $2 }' | uniq`
do
    cast cluster add $host
done
