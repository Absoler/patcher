@one_assign_and_other@
// 一对对立的赋值，加上只在某分支存在的live赋值，它的用途不是返回值
/*
    example: 1070

    int* func_19() {
        int32_t *b = g_7;
        int32_t *c = g_7;
        int32_t d = 2;
        if (g_31[0][1][5]) {
            *b = 5;
            d = 0;
        } else
            *b = 0;
        g_66 = d;
    }

    func_19():
    /home/csmith-2.3.0/test/output2.c:69
    401187:	0f b6 05 3d 30 00 00 	movzbl 0x303d(%rip),%eax        # 4041cb <g_31+0xb>
    40118e:	f6 d8                	neg    %al
    401190:	19 d2                	sbb    %edx,%edx
    401192:	83 e2 05             	and    $0x5,%edx
    401195:	80 3d 2f 30 00 00 01 	cmpb   $0x1,0x302f(%rip)        # 4041cb <g_31+0xb>
    40119c:	19 c0                	sbb    %eax,%eax
    40119e:	83 e0 02             	and    $0x2,%eax
    4011a1:	89 15 f5 30 00 00    	mov    %edx,0x30f5(%rip)        # 40429c <g_7>
    /home/csmith-2.3.0/test/output2.c:73
    4011a7:	89 05 1b 8f 00 00    	mov    %eax,0x8f1b(%rip)        # 40a0c8 <g_66>
    /home/csmith-2.3.0/test/output2.c:74
    4011ad:	c3                   	retq   
    
    71
*/
// 最好分支里不要有太复杂的成分，不然容易按分支去翻译而不是直接比较后赋值
expression  l, other, retVal;
global idexpression cond =~ "[a-z]";
assignment operator assi_op1, assi_op2;
position p;
identifier bad_call;    //we don't want this
expression base, pointer =~ "[a-z]";
identifier fld;
global idexpression g =~ "[a-z]";
constant r1, r2;
@@

(
// filter these two
if(<+... bad_call(...) ...+>){
    ...
}
|
if(<+... bad_call(...) ...+>){
    ...
}else{
    ...
}

|

*   if (
    <+... 
(
*   base@p -> fld
|
*   *pointer@p
|
*   g@p
) 
    ...+>) {
    ...
(   
*   l assi_op1 r1 \| l++ \| l-- \| ++l \| --l
) 
    ... when != return retVal;
} else {
    ...
(   
*   l assi_op2 r2 \| l++ \| l-- \| ++l \| --l
) 
    ...
*   other = ...
    ... when != return retVal;
}
<+... other ...+>

|
*   if (
    <+...
(
*   base@p -> fld
|
*   *pointer@p
|
*   g@p
) 
    ...+>) {
    ...
(   
*   l assi_op1 r1 \| l++ \| l-- \| ++l \| --l
)
    ... 
*   other = ...
    ... when != return retVal;
} else {
    ...
(   
*   l assi_op2 r2 \| l++ \| l-- \| ++l \| --l
)
    ... when != return retVal;
}
<+... other ...+>
)

@script:python@
//x << one_assign_and_other.cond;
p << one_assign_and_other.p;
@@
print "hit:"+p[0].line
#cocci.print_sec(p[0], "sec")