#!/bin/bash
grep "Failed password" auth.log | awk '{print $(NF-5)}' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
