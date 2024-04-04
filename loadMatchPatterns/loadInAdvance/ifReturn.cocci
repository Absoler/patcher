@load_retVal_inAdvance@
identifier func;
idexpression ret;
position p1, p2;
/*
    example: 1041

    gcc-12.1 -O1

    func_31(int c, int d) {
        if (c) {
            if (f){
                if (d)
                    func_58();
                return g_286;
            }
            g_286 = 0;
        }
        return 0;
    }


    func_31():
    4011d0:	89 f8                	mov    %edi,%eax
    4011d2:	85 ff                	test   %edi,%edi
    4011d4:	74 1f                	je     4011f5 <func_31+0x25>
    4011d6:	8b 05 84 2e 00 00    	mov    0x2e84(%rip),%eax        # 404060 <f>
    4011dc:	85 c0                	test   %eax,%eax
    4011de:	75 0b                	jne    4011eb <func_31+0x1b>
    4011e0:	c7 05 7a 2e 00 00 00 	movl   $0x0,0x2e7a(%rip)        # 404064 <g_286>
    4011e7:	00 00 00 
    4011ea:	c3                   	retq   
    4011eb:	8b 05 73 2e 00 00    	mov    0x2e73(%rip),%eax        # 404064 <g_286>
    4011f1:	85 f6                	test   %esi,%esi
    4011f3:	75 01                	jne    4011f6 <func_31+0x26>
    4011f5:	c3                   	retq   
    4011f6:	48 83 ec 10          	sub    $0x10,%rsp
    func_58():
    4011fa:	48 8d 44 24 88       	lea    -0x78(%rsp),%rax         # register spill
    4011ff:	48 89 05 82 8c 00 00 	mov    %rax,0x8c82(%rip)        # 409e88 <p>
    func_31():
    401206:	8b 05 58 2e 00 00    	mov    0x2e58(%rip),%eax        # 404064 <g_286>
    40120c:	48 83 c4 10          	add    $0x10,%rsp
    401210:	c3                   	retq
    
*/
@@
(

if(...){
    ...
(
    if(...)@p1{
        ...
        func(...)
        ...
    }
|
    if(...)@p1{
        ...
    }else{
        ...
        func(...)
        ...
    }
)
    ...
*   return <+... ret@p2 ...+>;
}

|

if(...){
    ...
}else{
    ...
(
    if(...)@p1{
        ...
        func(...)
        ...
    }
|
    if(...)@p1{
        ...
    }else{
        ...
        func(...)
        ...
    }
)
    ...
*   return <+... ret@p2 ...+>;
}

)

@script:python@
p1 << load_retVal_inAdvance.p1;
p2 << load_retVal_inAdvance.p2;
ret << load_retVal_inAdvance.ret = "";
@@
print("hit:" + p1[0].line + " " + p2[0].line)
target = ret
print("target: " + target)