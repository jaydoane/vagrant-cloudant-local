#!/bin/bash

DB_PREFIX=${DB_PREFIX-db}

for host in `grep ${DB_PREFIX}[0-9]*[0-9a-z.] /etc/hosts | awk '{ print $2 }' | uniq`
do
    #FIXME: cast cluster add $host
    # hack until above command works:
    curl -X PUT http://localhost:5986/nodes/cloudant@$host -H "Content-Type: application/json" -d '{}'
done
