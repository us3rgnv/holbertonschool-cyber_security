#!/bin/bash
grep -i "iptables.*A\|ufw.*add\|firewall.*add" auth.log | wc -l
