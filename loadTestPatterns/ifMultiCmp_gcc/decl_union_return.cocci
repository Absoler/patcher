@decl_union_return@
/*
    example: 1317

    union U3 func_17() {
        union U3 d[1] = {5, 4, 5, 3, 3, 1, 5, 2};
        for (; c;)
            ;
        if (g_134.f0) {
            union U3 e = {0, 0, 2, 9, 2, 9, 7, 5};
            return e;
        }
        return d[0];
    }

    func_17():
        /home/csmith-2.3.0/test/output2.c:155
        40118c:	48 89 f8             	mov    %rdi,%rax
        /home/csmith-2.3.0/test/output2.c:157
        40118f:	8b 15 d3 d7 00 00    	mov    0xd7d3(%rip),%edx        # 40e968 <c>
        /home/csmith-2.3.0/test/output2.c:157 (discriminator 1)
        401195:	85 d2                	test   %edx,%edx
        401197:	75 fc                	jne    401195 <func_17+0x9>
        /home/csmith-2.3.0/test/output2.c:159
        401199:	66 83 3d 9f 78 00 00 	cmpw   $0x1,0x789f(%rip)        # 408a40 <g_134>
        4011a0:	01 
        4011a1:	45 19 db             	sbb    %r11d,%r11d
        4011a4:	41 83 e3 05          	and    $0x5,%r11d
        4011a8:	66 83 3d 90 78 00 00 	cmpw   $0x0,0x7890(%rip)        # 408a40 <g_134>
        4011af:	00 
        4011b0:	b9 04 00 00 00       	mov    $0x4,%ecx
        4011b5:	0f 44 d1             	cmove  %ecx,%edx
        4011b8:	66 83 3d 80 78 00 00 	cmpw   $0x1,0x7880(%rip)        # 408a40 <g_134>

    这部分在match端考虑和struct合并
*/
global idexpression cond =~ "[a-z]";
identifier typeName;
identifier lvar;
position p;
@@
if ( <+...
*   cond@p ...+> ){
    ...
    union typeName lvar = {...};
    ...
    return lvar;
    ...
}

@script:python@
x << decl_union_return.cond;
p << decl_union_return.p;
@@
print("hit:" + p[0].line)
