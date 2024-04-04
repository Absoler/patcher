#! /usr/bin/python3
import os
import sys
import json
import re
"""
match source with patches, and output json file only
    args[1] specify the source dir, and we need match files in it recorded on `objs`
    args[2] specfiy the dir holding cocci patches we want to match with
    args[3] specfiy the path of `objs` file, which lists files that are compiled
    args[4] (if exists) specify the start index of `objs`
"""
files = os.popen(f"cat {sys.argv[3]}").readlines()
sum = len(files)
startIndex = 0
if len(sys.argv) == 5:
    startIndex = int(sys.argv[4])

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

    '''
        json format

        [
            file_name, 
            [
                {
                    "var" : <string>, 
                    "lineNo" : <string>
                } 
            ] 
        ]

    '''
    
    for pat in patterns:
        minfo = os.popen("timeout 16s spatch -j 8 --sp-file "+ pat + " " + file +" --no-includes").read()

        # lines = list(set(re.findall(r'hit\:(.*)\n', minfo)))
        # if len(lines) == 0:
        #     continue
        # js = json.dumps((file, lines))
        # print(js)

        json_data = [file, []]
        minfo_lst = minfo.split('\n')
        for i, line in enumerate(minfo_lst):
            if "hit" in line and "target" in minfo_lst[i+1]:
                lineStr = re.findall(r'hit\:\s*(.*)', line)
                var = re.findall(r'target\:\s*(.*)', minfo_lst[i+1])
                if len(var) == 0 or len(lineStr) == 0:
                    continue
                json_data[1].append({"var":var[0], "lineNo":lineStr[0]})
        


        if len(json_data[1]) == 0:
            continue
        js = json.dumps(json_data)
        print(js)