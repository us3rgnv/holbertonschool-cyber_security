#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 log.txt"
    exit 1
fi

logfile=$1

attacker=$(awk '{print $1}' "$logfile" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

awk -v ip="$attacker" '$1 == ip {count++} END {print count}' "$logfile"
