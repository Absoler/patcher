#! /usr/bin/python3
import os
import sys
import json
import re
"""
match source with patches, and output json file only
    args[1] specify the source dir, and we need match files in it recorded on `objs`
    args[2] specfiy the dir holding cocci patches we want to match with
"""
files = os.popen("cat ./objs").readlines()
for _file in files:
    file = (sys.argv[1]+"/"+_file).strip().replace(".o", ".c")
    patterns = []
    if sys.argv[2].endswith("/"):
        patterns = os.popen(f"ls {sys.argv[2]}").read().split("\n")
        patterns = [ sys.argv[2]+pat for pat in patterns if len(pat)>0 and pat.endswith(".cocci") ]
    else:
        patterns.append(sys.argv[2])
    
    # print(patterns)
    for pat in patterns:
        minfo = os.popen("timeout 2s spatch -j 2 --sp-file "+ pat + " " + file +" --no-includes").read()
        # print(f"minfo {minfo}")
        lines = list(set(re.findall(r'hit\:(.*)\n', minfo)))
        # print(f"lines {lines}")
        if len(lines) == 0:
            continue
        js = json.dumps((file, lines))
        print(js)