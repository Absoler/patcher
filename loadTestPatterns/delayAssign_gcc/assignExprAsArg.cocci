@assignExprAsArg@
/*
    example: 1682 load
    for struct and union, may cause duplicate copy

    gcc-12.1 -O1

    void func_1() {
        struct S0 a;
        func_15(a = g_20);
        g_27 = a.f2;
    }

    00000000004011a1 <func_1>:
    func_1():
    /home/csmith-2.3.0/test/output2.c:45
    4011a1:	53                   	push   %rbx
    /home/csmith-2.3.0/test/output2.c:47
    4011a2:	0f b7 1d cf 2e 00 00 	movzwl 0x2ecf(%rip),%ebx        # 404078 <g_20+0x8>
    4011a9:	48 8b 3d c0 2e 00 00 	mov    0x2ec0(%rip),%rdi        # 404070 <g_20>
    4011b0:	48 8b 35 c1 2e 00 00 	mov    0x2ec1(%rip),%rsi        # 404078 <g_20+0x8>
    4011b7:	e8 ca ff ff ff       	callq  401186 <func_15>
    /home/csmith-2.3.0/test/output2.c:48
    4011bc:	0f b7 db             	movzwl %bx,%ebx
    4011bf:	89 1d c3 8c 00 00    	mov    %ebx,0x8cc3(%rip)        # 409e88 <g_27>
    /home/csmith-2.3.0/test/output2.c:49
    4011c5:	5b                   	pop    %rbx
    4011c6:	c3                   	retq   

*/
expression struct sExp;
expression union uExp;
expression l,r;
global idexpression  g;
assignment operator op;
identifier func;
identifier f;
position p;
@@
(
*  func(..., l op sExp@p, ...)
|
*  func(..., l op uExp@p, ...)
)
...
l.f

@script:python@
p << assignExprAsArg.p;
@@ 
print("hit:"+p[0].line)