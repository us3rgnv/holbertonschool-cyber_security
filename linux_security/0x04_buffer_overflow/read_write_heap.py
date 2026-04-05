#!/usr/bin/python3
import sys

if len(sys.argv) != 4:
    print("Usage: read_write_heap.py pid search_string replace_string")
    sys.exit(1)

pid = sys.argv[1]
search = sys.argv[2].encode()
replace = sys.argv[3].encode()

if len(replace) > len(search):
    print("Error: replace string longer than search string")
    sys.exit(1)

heap_start = None
heap_end = None

with open("/proc/{}/maps".format(pid), "r") as f:
    for line in f:
        if "[heap]" in line:
            addr = line.split()[0]
            start, end = addr.split("-")
            heap_start = int(start, 16)
            heap_end = int(end, 16)
            break

if heap_start is None:
    print("Heap not found")
    sys.exit(1)

with open("/proc/{}/mem".format(pid), "rb+") as mem:
    mem.seek(heap_start)
    heap = mem.read(heap_end - heap_start)

    index = heap.find(search)
    if index == -1:
        print("String not found")
        sys.exit(1)

    mem.seek(heap_start + index)
    mem.write(replace + b"\x00" * (len(search) - len(replace)))
