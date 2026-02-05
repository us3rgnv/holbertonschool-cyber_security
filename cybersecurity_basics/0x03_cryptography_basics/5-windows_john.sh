#!/bin/bash
john --wordlist=/usr/share/wordlists/rockyou.txt --format=nt "$1"
