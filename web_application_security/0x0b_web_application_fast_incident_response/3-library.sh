#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 log.txt"
    exit 1
fi

logfile=$1

# 1. Attacker IP-ni tap
attacker=$(awk '{print $1}' "$logfile" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

# 2. Həmin IP üçün User-Agent-ləri çıxar və say
awk -v ip="$attacker" '$1 == ip' "$logfile" \
| awk -F'"' '{print $6}' \
| sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
