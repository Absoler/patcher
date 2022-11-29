@simpleReturn@
/*
    example: 1319 -O1

    uint8_t func_1() {
        g_266 = g_263;
        // g_107=2;
        return g_266;
    }

    0000000000401186 <func_1>:
    func_1():
    /home/csmith-2.3.0/test/output2.c:30
    401186:	8b 05 dc 2e 00 00    	mov    0x2edc(%rip),%eax        # 404068 <g_263>
    40118c:	48 89 05 cd 2e 00 00 	mov    %rax,0x2ecd(%rip)        # 404060 <g_266>
    #   /home/csmith-2.3.0/test/output2.c:31
    #   401193:	c6 05 d2 2e 00 00 02 	movb   $0x2,0x2ed2(%rip)        # 40406c <g_107>
    /home/csmith-2.3.0/test/output2.c:32
    401193:	0f b6 05 ce 2e 00 00 	movzbl 0x2ece(%rip),%eax        # 404068 <g_263>
    /home/csmith-2.3.0/test/output2.c:33
    40119a:	c3                   	retq 


*/
expression lhs, rval;
assignment operator op;
statement s;
position p1, p2;
@@

lhs@p1 op rval;
?s
*   return lhs@p2;

@script:python@
n << simpleReturn.lhs;
p1 << simpleReturn.p1;
p2 << simpleReturn.p2;
@@
print "hit:" + p1[0].line + " " + p2[0].line