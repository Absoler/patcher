#! /usr/bin/python3
import os
import sys
import json
import re
"""
match source with patches, and output json file only
    args[1] specify the source dir, and we need match files in it recorded on `objs`
    args[2] specfiy the dir holding cocci patches we want to match with
    args[3] (if exists) specify the start index of `objs`
"""
files = os.popen("cat ./objs").readlines()
sum = len(files)
startIndex = 0
if len(sys.argv) == 4:
    startIndex = int(sys.argv[3])

for i in range(startIndex, sum):
    file = (sys.argv[1]+"/"+files[i]).strip().replace(".o", ".c")
    if not os.path.exists(file):
        continue
    # print(f'\nprocessing {file} ...')
    patterns = []
    if sys.argv[2].endswith("/"):
        patterns = os.popen(f"find {sys.argv[2]} -name '*.cocci'").read().split("\n")
        # patterns = [ sys.argv[2]+pat for pat in patterns if len(pat)>0 and pat.endswith(".cocci") ]
    else:
        patterns.append(sys.argv[2])
    
    patterns = [ pat for pat in patterns if pat.strip() != "" ]
    # print(patterns)
    for pat in patterns:
        minfo = os.popen("timeout 10s spatch -j 2 --sp-file "+ pat + " " + file +" --no-includes").read()
        # print(f"minfo {minfo}")
        lines = list(set(re.findall(r'hit\:(.*)\n', minfo)))
        # print(f"lines {lines}")
        if len(lines) == 0:
            continue
        js = json.dumps((file, lines))
        print(js)