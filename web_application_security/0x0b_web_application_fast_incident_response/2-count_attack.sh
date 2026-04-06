#!/bin/bash

attacker=$(awk '{print $1}' logs.txt | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')

awk -v ip="$attacker" '$1 == ip {count++} END {print count}' logs.txt
