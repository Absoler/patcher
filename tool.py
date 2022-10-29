#! /usr/bin/python3

'''
    1. (不提供参数) 将matched.out记录的文件重新匹配，获得每个源码文件的匹配行号，输出至stdout
    2. （提供pair） 将该对参数重新匹配，输出json文件
'''
import os
import re
import json
import sys
pairs = []  # pass pair or read from matched.out
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