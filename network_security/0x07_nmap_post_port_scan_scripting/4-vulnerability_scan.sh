#!/bin/bash
nmap --script="http-vuln* mysql-vuln* ftp-vuln* smtp-vuln*" -oN vulnerability_scan_results.txt "$1"
