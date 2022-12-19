@union_assign@
/*
    example: 662

    union U1 {
    uint16_t  f0;
    int32_t  f1;
    int8_t * f2;
    uint32_t  f3;
    uint8_t  f4;
    };


    int32_t g_129[10][4] = ...;
    int64_t g_287[6] = ...;
    char ch;
    int s;

    void func_13(union U1 c) {
        c.f1 = g_129[7][0];
        g_287[0] = c.f2;
        if (g_287[0])
            c.f1 = 1;
        s = c.f3;   // 这个field是谁都行，主要是再用到一次局部变量c
    }

    // 对c.f1的第二次写触发了引入写前读

    func_13():
    /home/csmith-2.3.0/test/output2.c:42
    401186:	8b 05 a4 2f 00 00    	mov    0x2fa4(%rip),%eax        # 404130 <g_129+0x70>
    40118c:	48 ba 00 00 00 00 ff 	movabs $0xffffffff00000000,%rdx
    401193:	ff ff ff 
    401196:	48 21 d7             	and    %rdx,%rdi    # rdi保存了c的高32位
    401199:	48 09 c7             	or     %rax,%rdi    # 拿g_129[7][0]写到低32位
    /home/csmith-2.3.0/test/output2.c:43
    40119c:	48 89 3d dd 2e 00 00 	mov    %rdi,0x2edd(%rip)        # 404080 <g_287>
    /home/csmith-2.3.0/test/output2.c:45
    4011a3:	b8 01 00 00 00       	mov    $0x1,%eax
    4011a8:	0f 44 05 81 2f 00 00 	cmove  0x2f81(%rip),%eax        # 404130 <g_129+0x70>
    /home/csmith-2.3.0/test/output2.c:46
    4011af:	89 05 b3 8d 00 00    	mov    %eax,0x8db3(%rip)        # 409f68 <s>
    /home/csmith-2.3.0/test/output2.c:47
    4011b5:	c3                   	retq   
    
*/
expression union u;
expression g;   // double-read obj  不清楚为什么这里不能加正则"^g_"
identifier f1, f2, f3;
expression other;
position p1, p2;
assignment operator assi_op1, assi_op2, assi_op3;
@@

*   u.f1 assi_op1 g@p1;
...
(
    other assi_op2 u;
|
    other assi_op2 u.f2;
)
...
if(other){
    ...
*   u.f1 assi_op3 ...;@p2
    ...
}
...
u.f3

@script:python@
p1 << union_assign.p1;
p2 << union_assign.p2;
@@
print "hit: " + p1[0].line + " " + p2[0].line