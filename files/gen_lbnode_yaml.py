import os
import re
import sys
import yaml

PREFIX = os.environ.get('DB_PREFIX') or 'db'

HOST_RE = '^(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})\s+(%s\d+[\w.]*)'

def main():
    d = {
        'lbnode': {
            'users': {
                'admin': 'pass'
            },
            'nodes': prefixed_hosts()
        }
    }
    sys.stdout.write(yaml.dump(d, default_flow_style=False))

def prefixed_hosts(infile=sys.stdin):
    pattern = HOST_RE % PREFIX
    hosts = []
    for line in infile:
        m = re.match(pattern, line)
        if m:
            hosts.append({'hostname': m.group(2),
                          'ipaddress': m.group(1)})
    return hosts

if __name__ == '__main__':
    main()
