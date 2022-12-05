@ two_things@
/*
    example: 1054

    a,b,c,d are locals
    if (g_389[2][5][2]){
        c = b;
        a = c;
    }
        
    if (d = c)
        g_100 = d;
    return a;

    0000000000401186 <func_1>:
    func_1():
    /home/csmith-2.3.0/test/output2.c:113
    401186:	66 83 3d 0e 50 00 00 	cmpw   $0x1,0x500e(%rip)        # 40619c <g_389+0x9c>
    40118d:	01 
    40118e:	19 d2                	sbb    %edx,%edx
    401190:	83 e2 fd             	and    $0xfffffffd,%edx
    401193:	83 c2 04             	add    $0x4,%edx
    401196:	66 83 3d fe 4f 00 00 	cmpw   $0x1,0x4ffe(%rip)        # 40619c <g_389+0x9c>
    40119d:	01 
    40119e:	19 c0                	sbb    %eax,%eax
    4011a0:	83 c0 04             	add    $0x4,%eax
    /home/csmith-2.3.0/test/output2.c:121
    4011a3:	89 15 73 5c 00 00    	mov    %edx,0x5c73(%rip)        # 406e1c <g_100>
    /home/csmith-2.3.0/test/output2.c:122
    4011a9:	0f b6 c0             	movzbl %al,%eax
    /home/csmith-2.3.0/test/output2.c:123
    4011ac:	c3                   	retq 

    //1054 3242

    problem: weak in alias analyse
    103:
    struct S0 func_2(uint16_t a) {
        int32_t *b = &g_6;
        int32_t **e = &b;
        int32_t *c = &g_335;
        uint32_t d = 0;
        if (g_12[6][6][3]) {
            *e = g_12;
            d++;
        }
        *c = d;
        *b = 0;
    }

    e points to b, which will be used as an address. So write to e is live too.

    func_2():
    /home/csmith-2.3.0/test/output2.c:97
    401196:	83 3d 4f 34 00 00 00 	cmpl   $0x0,0x344f(%rip)        # 4045ec <g_12+0x36c>
    40119d:	b8 80 42 40 00       	mov    $0x404280,%eax
    4011a2:	ba 04 46 40 00       	mov    $0x404604,%edx
    4011a7:	48 0f 44 c2          	cmove  %rdx,%rax
    4011ab:	83 3d 3a 34 00 00 01 	cmpl   $0x1,0x343a(%rip)        # 4045ec <g_12+0x36c>
    4011b2:	19 d2                	sbb    %edx,%edx
    4011b4:	83 c2 01             	add    $0x1,%edx
    ...

*/

global idexpression cond =~ "[a-z]", g1, g2;
expression l1, l2, r1, r2;
assignment operator op1, op2, op3, op4;
position p;
//严格限制后续使用必须是紧邻语句的if-cond、return、赋值给global
@@
if(<+...
*   cond@p ...+>){
    ...
(   
    l1 op1 r1   \|  l1++ \| ++l1    \|   l1-- \| --l1
)
    ...
(   l2 op2 r2   \|  l2++ \| ++l2    \|   l2-- \| --l2
)
    ...
}
(

// use l1, l2
(
*   if(<+... l1 ...+>){
        ...
    }
|
*   if(<+... l1 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l1 ...+>;
|
    (<+... 
*   g1 ...+>) op3 l1; 
|
*   callee(..., l1, ...);
)

(
*   if(<+... l2 ...+>){
        ...
    }
|
*   if(<+... l2 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l2 ...+>;
|
    (<+...
*   g2 ...+>) op4 l2; 
|
*   callee(..., l2, ...);
)

|

// use l2, l1
(
*   if(<+... l2 ...+>){
        ...
    }
|
*   if(<+... l2 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l2 ...+>;
|
    (<+...
*   g2 ...+>) op4 l2;
|
*   callee(..., l2, ...); 
)

(
*   if(<+... l1 ...+>){
        ...
    }
|
*   if(<+... l1 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l1 ...+>;
|
    (<+... 
*   g1 ...+>) op3 l1; 
|
*   callee(..., l1, ...); 
)

)

@script:python@
p <<  two_things.p;
x <<  two_things.cond;
l1 <<  two_things.l1;
l2 <<  two_things.l2;
@@
print "hit:" + p[0].line
#print " cond: " + x
#print " l1: " + l1
#print " l2: " + l2