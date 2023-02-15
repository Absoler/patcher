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



    example: 1555

    gcc-12.1 -O3

    int divisor = 7;
    void __attribute_noinline__ func_1() {
        int *a = g_4;
        int b = 5, d = 1;
        g_217 || (d = b);
        g_4 = d;
        if ((g_235 = d) % divisor) {
            g_4 = 0;
        }
    }

    0000000000401fe0 <func_1>:
    func_1():
    /home/csmith_load_o3/test/output2.c:75
    401fe0:	48 83 3d 38 31 00 00 	cmpq   $0x1,0x3138(%rip)        # 405120 <g_217>
    401fe7:	01 
    401fe8:	19 c0                	sbb    %eax,%eax
    401fea:	83 e0 04             	and    $0x4,%eax
    401fed:	83 c0 01             	add    $0x1,%eax
    401ff0:	48 83 3d 28 31 00 00 	cmpq   $0x1,0x3128(%rip)        # 405120 <g_217>
    401ff7:	01 
    401ff8:	19 c9                	sbb    %ecx,%ecx
    /home/csmith_load_o3/test/output2.c:77
    401ffa:	88 05 c8 30 00 00    	mov    %al,0x30c8(%rip)        # 4050c8 <g_235>
    /home/csmith_load_o3/test/output2.c:75
    402000:	83 e1 04             	and    $0x4,%ecx
    402003:	83 c1 01             	add    $0x1,%ecx
    /home/csmith_load_o3/test/output2.c:77
    402006:	89 c8                	mov    %ecx,%eax
    402008:	99                   	cltd   
    402009:	f7 3d 71 30 00 00    	idivl  0x3071(%rip)        # 405080 <divisor>
    /home/csmith_load_o3/test/output2.c:78
    40200f:	31 c0                	xor    %eax,%eax
    402011:	85 d2                	test   %edx,%edx
    402013:	0f 45 c8             	cmovne %eax,%ecx
    402016:	89 0d 94 42 00 00    	mov    %ecx,0x4294(%rip)        # 4062b0 <g_4>
    /home/csmith_load_o3/test/output2.c:81
    40201c:	c3                   	retq   
    40201d:	0f 1f 00             	nopl   (%rax)

// 2135
*/
identifier func;
idexpression g;
expression el,e1,e2;
position p;
@@
(
* func(..., <+... <+... g ...+> || <+... e1 = e2@p ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2@p ...+> || <+... g ...+> ...+> ,...)
|
* func(..., <+... <+... g ...+> && <+... e1 = e2@p ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2@p ...+> && <+... g ...+> ...+> ,...)
| 
* func(..., <+... <+... g ...+> | <+... e1 = e2@p ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2@p ...+> | <+... g ...+> ...+> ,...)
|
* func(..., <+... <+... g ...+> & <+... e1 = e2@p ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2@p ...+> & <+... g ...+> ...+> ,...)
|
*   el || <+... e1 = e2@p ...+>  \|
*   <+... e1 = e2@p ...+> || el
|
*   el | <+... e1 = e2@p ...+>  \|
*   <+... e1 = e2@p ...+> | el
|
*   el && <+... e1 = e2@p ...+>  \|
*   <+... e1 = e2@p ...+> && el
|
*   el & <+... e1 = e2@p ...+>  \|
*   <+... e1 = e2@p ...+> & el
)

@script:python@
p << Assign_with_logic.p;
@@
print("hit: " + p[0].line)