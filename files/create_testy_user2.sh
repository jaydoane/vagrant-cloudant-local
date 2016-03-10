#!/bin/bash -e

curl -X PUT http://localhost:5984/_users/org.couchdb.user:user2 -H "Accept: application/json" -H "Content-Type: application/json" -d '{"name": "user2", "password": "pass", "type": "user"}' -u admin:{{ admin_password }}
