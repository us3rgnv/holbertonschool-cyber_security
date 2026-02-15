#!/bin/bash
grep -Ev '^\s*#|^\s*$' /etc/ssh/sshd_config
