#! /usr/bin/env python3

import os
import re
import sys

filename_pattern = r"^output\.(log|err)-(?P<rank>\d+)-(?P<host>[\w\d-]+)$"
filename_prog = re.compile(filename_pattern)

hfi_selected_pattern = r"^.*\sSelected\sHFI\sis\s(?P<hfi_unit>\d+);\s.*$"
hfi_selected_pattern_prog = re.compile(hfi_selected_pattern)
hfi_contexts = {}

def update_hfi_distribution(host, hfi_unit, count):
    if host not in hfi_contexts:
        hfi_contexts[host] = {}

    if hfi_unit not in hfi_contexts[host]:
        hfi_contexts[host][hfi_unit] = 0

    hfi_contexts[host][hfi_unit] += count

def get_rank_and_host(filename):
    result = filename_prog.match(filename)
    if result:
        return result["rank"], result["host"]
    else:
        return None, None

def get_hfi_unit_number(line):
    result = hfi_selected_pattern_prog.match(line)
    if result:
        return result["hfi_unit"]
    else:
        return None

for filename in os.listdir(os.path.abspath("/tmp/srtest")):
    rank, host = get_rank_and_host(filename)
    if host is None or rank is None:
        print("Failed to get rank and host from filename")
        sys.exit(1)

    with open(os.path.join("/tmp/srtest", filename), 'r') as f:
        for line in f.readlines():
            hfi_unit = get_hfi_unit_number(line)
            if hfi_unit:
                update_hfi_distribution(host, hfi_unit, 1)
for host in hfi_contexts:
    print(f"-------- {host} --------")
    for hfi_unit in hfi_contexts[host]:
        print(f"hfi1_{hfi_unit}: {hfi_contexts[host][hfi_unit]} contexts opened.")

