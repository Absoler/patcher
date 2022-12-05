@parm_deref_assign@
//2054 1786 s可以是和其余变量无关的global赋值等语句 3801不需要 O2似乎无效
// 对于分支内的写，选择在不进入分支时将变量读出并原样写入，等于多引入一次连续的读写
/*
    example: 2054

    void func_2( int32_t *b, int32_t *c) {
        *b = 1;
        *c = 0;
        if (g)
            *b = 10;
    }

    func_2():
    /home/csmith-2.3.0/test/output2.c:36
    401186:	c7 07 01 00 00 00    	movl   $0x1,(%rdi)
    /home/csmith-2.3.0/test/output2.c:37
    40118c:	c7 06 00 00 00 00    	movl   $0x0,(%rsi)
    /home/csmith-2.3.0/test/output2.c:39
    401192:	b8 0a 00 00 00       	mov    $0xa,%eax
    /home/csmith-2.3.0/test/output2.c:38
    401197:	83 3d ea 8c 00 00 00 	cmpl   $0x0,0x8cea(%rip)        # 409e88 <g>
    40119e:	75 02                	jne    4011a2 <func_2+0x1c>
    /home/csmith-2.3.0/test/output2.c:39
    4011a0:	8b 07                	mov    (%rdi),%eax
    4011a2:	89 07                	mov    %eax,(%rdi)
    /home/csmith-2.3.0/test/output2.c:40
    4011a4:	c3                   	retq   
*/
identifier id , func;
expression e1,e2;
global idexpression cond;
type t;
statement s;
position p;
@@
func(..., t id ,...){
...
    *id = e1
...
s

(
if ( <+... cond ...+> ) {
    ...
} else {
    <+... 
*   *id = e2@p ...+>
}

|

if ( <+... cond ...+> ) {
    <+... 
*   *id = e2@p ...+>
} else {
    ...
}

|

if ( <+... cond ...+> ) {
    <+... 
*   *id = e2@p ...+>
} 
)
...
}

@script:python@
cond << parm_deref_assign.cond;
id << parm_deref_assign.id;
p << parm_deref_assign.p;
@@
#print "cond:    " + cond
print "id:  " + id
print "hit:" + p[0].line