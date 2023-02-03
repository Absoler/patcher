@decl_const_union@
identifier utype, u;
@@
(
    union utype u[...] = ...; 
|
    union utype u = ...; 
)

@assign_const_union depends on decl_const_union@
identifier decl_const_union.u;
expression lval;
/*
    gcc-12.1 -O2

    union U1 {
        int  f0;
        unsigned long int  f1;
    };

    union U1 g_52 = {0x4523830AL};

    void __attribute__ ((noinline)) func_7() {
        const union U1 d[2] = {6,6,6};      
        // 780 不需要 const
        g_52 = d[0];
    }


    0000000000401280 <func_7>:
    func_7():
    /home/csmith_store/test/output2.c:35
    401280:	48 c7 05 d5 2d 00 00 	movq   $0x0,0x2dd5(%rip)        # 404060 <g_52>
    401287:	00 00 00 00 
    40128b:	c7 05 cb 2d 00 00 06 	movl   $0x6,0x2dcb(%rip)        # 404060 <g_52>
    401292:	00 00 00 
    /home/csmith_store/test/output2.c:36
    401295:	c3                   	retq   
    401296:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    40129d:	00 00 00 

    // 会多一个初始化为0的步骤
*/
@@

(
*   lval = u[...]
|
*   lval = u
)
