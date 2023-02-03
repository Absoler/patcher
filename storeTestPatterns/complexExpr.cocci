@logic_expr@
/*
    example: 
    gcc-12.1 -O2

    int g1;
    int64_t __attribute_noinline__ func_1() {
        g_308 = (g_248.f2 = 1 && 1 & g1) ;
    }

    0000000000401230 <func_1>:
    func_1():
    /home/csmith_store_o2/test/output2.c:82
    401230:	8b 05 96 ea 20 00    	mov    0x20ea96(%rip),%eax        # 60fccc <g1>
    401236:	88 05 66 0c 20 00    	mov    %al,0x200c66(%rip)        # 601ea2 <g_248+0x2>
    40123c:	83 e0 01             	and    $0x1,%eax
    40123f:	80 25 5c 0c 20 00 01 	andb   $0x1,0x200c5c(%rip)        # 601ea2 <g_248+0x2>
    401246:	89 05 54 0b 20 00    	mov    %eax,0x200b54(%rip)        # 601da0 <g_308>

*/
binary operator op1 =~ "!=|&|\|", op2 =~ "!=|&|\|";
assignment operator op3 =~ "&=|\|=", op4 =~ "&=|\|=";
expression e1, e2, e3;
position p;
@@

(
*   (e1 op1 e2) op2@p e3
|
*   e1 op1@p (e2 op2 e3)

|
*   (e1 op3 e2) op4@p e3
|
*   e1 op3@p (e2 op4 e3)

|
*   (e1 op1 e2) op3@p e3
|
*   e1 op1@p (e2 op3 e3)

|
*   (e1 op3 e2) op1@p e3
|
*   e1 op3@p (e2 op1 e3)
)

@script:python@
op1 << logic_expr.op1;
op2 << logic_expr.op2;
p << logic_expr.p;
@@
print(op1+" "+op2)
print("hit: " + p[0].line)