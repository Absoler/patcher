@Assign_with_logic@
/*
    example: 1140 load

    gcc-12.1 -O1

    int f = 0;
    void func_1() {
        int b[2] = {3, 2};
        g_218 = b;
        func_2(g_8 || ((b[1] = 5) >> 6));
    }

    0000000000401197 <func_1>:
    func_1():
    /home/csmith-2.3.0/test/output2.c:31
    401197:	48 83 ec 10          	sub    $0x10,%rsp
    /home/csmith-2.3.0/test/output2.c:32
    40119b:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%rsp)
    4011a2:	00 
    /home/csmith-2.3.0/test/output2.c:33
    4011a3:	48 8d 44 24 08       	lea    0x8(%rsp),%rax
    4011a8:	88 05 b2 2e 00 00    	mov    %al,0x2eb2(%rip)        # 404060 <g_218>
    /home/csmith-2.3.0/test/output2.c:34
    4011ae:	83 3d d7 8c 00 00 01 	cmpl   $0x1,0x8cd7(%rip)        # 409e8c <g_8>
    4011b5:	19 c0                	sbb    %eax,%eax
    4011b7:	83 e0 03             	and    $0x3,%eax
    4011ba:	83 c0 02             	add    $0x2,%eax
    4011bd:	83 3d c8 8c 00 00 01 	cmpl   $0x1,0x8cc8(%rip)        # 409e8c <g_8>
    4011c4:	19 ff                	sbb    %edi,%edi
    4011c6:	83 c7 01             	add    $0x1,%edi
    4011c9:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    4011cd:	e8 b4 ff ff ff       	callq  401186 <func_2>
    /home/csmith-2.3.0/test/output2.c:35
    4011d2:	48 83 c4 10          	add    $0x10,%rsp
    4011d6:	c3                   	retq   
*/
identifier func;
idexpression g;
expression e1,e2;
@@
(
* func(..., <+... <+... g ...+> || <+... e1 = e2 ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2 ...+> || <+... g ...+> ...+> ,...)
|
* func(..., <+... <+... g ...+> && <+... e1 = e2 ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2 ...+> && <+... g ...+> ...+> ,...) 
)