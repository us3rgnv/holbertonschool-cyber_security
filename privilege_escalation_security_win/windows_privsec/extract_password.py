#!/usr/bin/env python3

import os
import re

COMMON_LOCATIONS = [
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Windows\Panther\Unattend\Unattend.xml",
    r"C:\Windows\System32\Sysprep\sysprep.inf",
    r"C:\autounattend.xml",
]

PATTERN = re.compile(
    r"<AdministratorPassword>.*?<Value>(.*?)</Value>.*?</AdministratorPassword>",
    re.IGNORECASE | re.DOTALL,
)

for path in COMMON_LOCATIONS:
    if not os.path.exists(path):
        continue

    print(f"[+] Found: {path}")

    try:
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()

        if PATTERN.search(content):
            print("    [!] AdministratorPassword section detected")
        else:
            print("    [-] No AdministratorPassword section found")

    except Exception as e:
        print(f"    [!] Error reading file: {e}")
