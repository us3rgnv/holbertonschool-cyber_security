#!/bin/bash
hashcat -a 1 --stdout "$1" "$2"
