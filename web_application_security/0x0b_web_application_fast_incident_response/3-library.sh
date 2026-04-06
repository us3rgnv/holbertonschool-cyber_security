#!/bin/bash
attacker=$(awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
awk -v ip="$attacker" '$1 == ip' logs.txt \
| awk -F'"' '{print $6}' \
| sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
