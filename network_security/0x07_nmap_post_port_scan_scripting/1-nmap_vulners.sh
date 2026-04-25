#!/bin/bash
nmap -sC -p 80,443 --script vulners  $1
