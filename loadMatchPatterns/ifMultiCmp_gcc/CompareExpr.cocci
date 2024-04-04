@compare_in_expr@
/*
    example: 4613

    gcc-12.1 -O2

    g_339 = (g_276[0] = (9U >= g_46) + 3) + (unsigned short)*a;

    func_1():
    /home/csmith-2.3.0/test/output2.c:81
    4020c0:	83 3d b5 34 00 00 0a 	cmpl   $0xa,0x34b5(%rip)        # 40557c <g_46>
    4020c7:	19 d2                	sbb    %edx,%edx
    4020c9:	83 3d ac 34 00 00 0a 	cmpl   $0xa,0x34ac(%rip)        # 40557c <g_46>
    4020d0:	19 c0                	sbb    %eax,%eax
    4020d2:	f7 d2                	not    %edx
    4020d4:	f7 d0                	not    %eax
    4020d6:	83 c0 04             	add    $0x4,%eax
    4020d9:	66 89 05 d0 31 00 00 	mov    %ax,0x31d0(%rip)        # 4052b0 <g_276>
    4020e0:	0f b7 05 a9 34 00 00 	movzwl 0x34a9(%rip),%eax        # 405590 <g_7>
    4020e7:	8d 44 02 04          	lea    0x4(%rdx,%rax,1),%eax
    4020eb:	48 98                	cltq   
    4020ed:	48 89 05 9c 2f 00 00 	mov    %rax,0x2f9c(%rip)        # 405090 <g_339>
    

    example: 4357

    g_98[4][0] = g_280 = (g_234.f3 < 1) + 3;

    func_1():
    /home/csmith-2.3.0/test/output2.c:99
    4024b0:	48 8b 05 99 33 00 00 	mov    0x3399(%rip),%rax        # 405850 <g_234+0x10>
    4024b7:	48 8b 0d 92 33 00 00 	mov    0x3392(%rip),%rcx        # 405850 <g_234+0x10>
    4024be:	48 f7 d8             	neg    %rax
    4024c1:	19 c0                	sbb    %eax,%eax
    4024c3:	83 c0 04             	add    $0x4,%eax
    4024c6:	48 f7 d9             	neg    %rcx
    4024c9:	18 d2                	sbb    %dl,%dl
    4024cb:	89 05 6f 35 00 00    	mov    %eax,0x356f(%rip)        # 405a40 <g_98+0x60>
    4024d1:	83 c2 04             	add    $0x4,%edx
    4024d4:	88 15 2e 33 00 00    	mov    %dl,0x332e(%rip)        # 405808 <g_280>

    // load and assign separately

    is necessary to add expr `&addr` as cond object
*/
expression cond, addr;
binary operator cmp = {>, <, ==, !=, <=, >=};
binary operator op1;
constant c1, c2;
expression e1, e2;
position p;
@@
(
*   (c1 cmp cond) op1 c2@p
|
*   c2 op1 (c1 cmp cond)@p
|
*   (cond cmp c1) op1 c2@p
|
*   c2 op1 (cond cmp c1)@p
|
*   e1 && (cond cmp e2)@p
|
*   cond cmp e2@p && e1
|
*   e1 || (cond cmp e2)@p
|
*   cond cmp e2@p || e1
)

@script:python@
p << compare_in_expr.p;
cond << compare_in_expr.cond = "";
@@ 
print("hit:" + p[0].line)
target = cond
print("target: " + target)
