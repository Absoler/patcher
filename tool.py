#! /usr/bin/python3

'''
    1. (不提供参数) 将matched.out记录的文件重新匹配，获得每个源码文件的匹配行号，输出至stdout
    2. （提供pair） 将该对参数重新匹配，输出json
    3. 将给定目录的代码用给定pattern匹配，输出json  
        args[1]: 代码目录   
        args[2]: 所用pattern（可以是某目录下的所有pattern）
        最好都给绝对路径 
'''
import os
import re
import json
import sys
from pathlib import Path
pairs = []  # pass pair or read from matched.out
VERSION = 3
if VERSION != 3:
    if len(sys.argv) > 1:
        pairs = [ sys.argv[1] + " " + sys.argv[2] ]
    else:
        pairs = os.popen("cat ./matched.out").read().split("\n")

    for pair in pairs:
        minfo = os.popen("timeout 10s spatch -j 2 --sp-file "+ pair +" --no-includes").read()
        lines = re.findall(r'hit\:(.*)\n', minfo)
        srcfile = pair.split()[1]
        lines = list(set(lines))
        js = json.dumps((srcfile, lines))
        # out.write(srcfile+"\n")
        # for line in lines:
        #     out.write(line.strip()+"\n")
        print(js)
else:
    _src = Path(sys.argv[1])
    if _src.is_dir():
        files = os.popen(f'find {sys.argv[1]} -name "*.c"').readlines()
        files = [ file.strip() for file in files if len(file) > 0 ]
    else:
        files = [sys.argv[1]]
    for file in files:
        # print(file)
        _pat = Path(sys.argv[2])
        patterns = []
        if _pat.is_dir():
            patterns = os.popen(f'find {sys.argv[2]} -name "*.cocci"').readlines()
            patterns = [ pat.strip() for pat in patterns if len(pat)>0 ]
        else:
            patterns.append(sys.argv[2])
        
        # print(patterns)
        for pat in patterns:
            minfo = os.popen("timeout 10s spatch -j 8 --sp-file "+ pat + " " + file +" --no-includes").read()

            # print("\n\n\n")
            # print(minfo)
            # print("\n\n\n")
            # print(f"minfo {minfo}")

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

            json_data = [file, []]
            minfo_lst = minfo.split('\n')
            for i, line in enumerate(minfo_lst):
                if "hit" in line and "target" in minfo_lst[i+1]:
                    lineStr = re.findall(r'hit\:\s*(.*)', line)
                    var = re.findall(r'target\:\s*(.*)', minfo_lst[i+1])
                    # print(lineStr)
                    # print(var)
                    json_data[1].append({"var":var[0], "lineNo":lineStr[0]})
            


            # lines = list(set(re.findall(r'hit\:\s*(.*)\n', minfo)))
            # print(f"lines {lines}")
            # if len(lines) == 0:
            #     continue
            if len(json_data[1]) == 0:
                continue
            js = json.dumps(json_data)
            print(js)