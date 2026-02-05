#!/bin/bash
find "$1" -type f -perm /6000 2>/dev/null -exec ls -l {} \;
