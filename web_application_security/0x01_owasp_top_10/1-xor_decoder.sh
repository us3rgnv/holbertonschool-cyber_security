#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 {xor}HASH"
    exit 1
fi
encoded_string="${1#\{xor\}}"
echo "$encoded_string" | base64 -d | perl -pe '$_ ^= "_" x length'
echo ""
