#!/bin/bash
grep -oP 'pam_unix\(\K[^:]+' auth.log | sort | uniq -c | sort -nr
