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
pairs = []  # pass pair or read from matched.out
VERSION = 3
if VERSION != 3:
    if len(sys.argv) > 1:
        pairs = [ sys.argv[1] + " " + sys.argv[2] ]
    else:
        pairs = os.popen("cat ./matched.out").read().split("\n")

    for pair in pairs:
        minfo = os.popen("timeout 2s spatch -j 2 --sp-file "+ pair +" --no-includes").read()
        lines = re.findall(r'hit\:(.*)\n', minfo)
        srcfile = pair.split()[1]
        lines = list(set(lines))
        js = json.dumps((srcfile, lines))
        # out.write(srcfile+"\n")
        # for line in lines:
        #     out.write(line.strip()+"\n")
        print(js)
else:
    files = os.popen(f"ls {sys.argv[1]} | grep '\.c'")
    for _file in files:
        file = (sys.argv[1]+"/"+_file).strip()
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