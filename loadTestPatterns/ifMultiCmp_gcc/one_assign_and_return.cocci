@one_assign_and_return@
// 本pattern描述：在不同分支，对一个live变量的赋值不同，返回值也不同
//      |
//      a
//     / \
//    b   c
//    ret |
//     \ /
//      d
//      |
//     ret
// 主路径末尾return的匹配一般省略，因为必定存在
// a,b,c,d是四个对live global的赋值位置
//  a可以代表对任一分支的赋值，因为if条件不确定=
//  b确定是对左侧分支的赋值
//  cd确定是对右侧分支的赋值
// 因而共有5种组合 ac, ad, bc, bd, ab  // (ab*cd)+(acd*b)-b*cd
// 加上对左侧属于true or false的讨论，共10种情况
//
// 如果是对相同变量的赋值，但使用了不相同的指针，那将无法辨认
// 
expression l, e, retVal;
assignment operator assi_op1, assi_op2;
identifier bad_call;    //we don't want this
global idexpression cond =~ "[a-z]";
expression base, pointer =~ "[a-z]";
identifier fld;
global idexpression g =~ "[a-z]";
statement s;
position p;
@@
(
// filter if which has call in cond
/*
don't need for test
* if(<+... bad_call(...) ...+>){
    ...
}
|
* if(<+... bad_call(...) ...+>){
    ...
}else{
    ...
}

|
*/

// **********
//  bc
// **********
/*
    // 3710 3549
    example: 3549
// 这里其实有别名的问题，对c和d的写并没有被识别到，识别的是引用g_40
    uint32_t func_11() {
        uint64_t a = 4;
        int32_t b;
        if (g_55[3]) {
            int32_t *c = &g_40;
            *c = 0;
        } else {
            int32_t *d = &g_40;
            *d = b = 8;
            return b;
        }
        return a;
    }

    func_11():
    /home/csmith-2.3.0/test/output2.c:64
    401186:	80 3d de 2e 00 00 01 	cmpb   $0x1,0x2ede(%rip)        # 40406b <g_55+0x3>
    40118d:	19 d2                	sbb    %edx,%edx
    40118f:	83 e2 08             	and    $0x8,%edx
    401192:	80 3d d2 2e 00 00 01 	cmpb   $0x1,0x2ed2(%rip)        # 40406b <g_55+0x3>
    401199:	19 c0                	sbb    %eax,%eax
    40119b:	83 e0 04             	and    $0x4,%eax
    40119e:	83 c0 04             	add    $0x4,%eax
    4011a1:	89 15 01 8d 00 00    	mov    %edx,0x8d01(%rip)        # 409ea8 <g_40>
    /home/csmith-2.3.0/test/output2.c:71
    4011a7:	c3                   	retq

*/
if ( <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
) 
    ...+> ){
    ...
*   l assi_op1 ...
    ...
}else{
    ...
*   l assi_op2 ...
    ...
*   return retVal;
}

|
//改变了return的位置
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
) 
    ...+>
    ){
    ...
*   l assi_op1 ...
    ...
*   return retVal;
}else{
    ...
*   l assi_op2 ...
    ...
}


|
// **********
//  ad
// **********
/*
// 1059 2964
    example: 2964

    int func_1() {
        int *b = &g_287;
        *b = &g_305 != 0;
        if (g_353[6])
            return 3;
        *b = 0;
        return 5;
    }

    func_1():
    /home/csmith-2.3.0/test/output2.c:115
    401186:	66 83 3d 2e 3f 00 00 	cmpw   $0x1,0x3f2e(%rip)        # 4050bc <g_353+0xc>
    40118d:	01 
    40118e:	19 d2                	sbb    %edx,%edx
    401190:	83 c2 01             	add    $0x1,%edx
    401193:	66 83 3d 21 3f 00 00 	cmpw   $0x1,0x3f21(%rip)        # 4050bc <g_353+0xc>
    40119a:	01 
    40119b:	19 c0                	sbb    %eax,%eax
    40119d:	83 e0 02             	and    $0x2,%eax
    4011a0:	83 c0 03             	add    $0x3,%eax
    4011a3:	89 15 97 3f 00 00    	mov    %edx,0x3f97(%rip)        # 405140 <g_287>
    /home/csmith-2.3.0/test/output2.c:117
    4011a9:	c3                   	retq 

*/
*   l assi_op1 ... ;
?   s
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){
    ...
*   return retVal;
}
...
*   l assi_op2 ...

|

*   l assi_op1 ... ;
?   s
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){
    ...
}else{
    ...
*   return retVal;
}
...
*   l assi_op2 ...


|
// **********
//  ab
// **********
//107 3265
*   l assi_op1 ... ;
?   s
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){
    ...
*   l assi_op2 ...
    ...
*   return retVal;
}

|

*   l assi_op1 ... ;
?   s
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){...}else{
    ...
*   l assi_op2 ...
    ...
*   return retVal;
}


|
// **********
//  ac
// **********
*  l assi_op1 ...;
?   s
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){
    ...
*   return retVal;
}else{
    ...
*   l assi_op2 ...
    ...
}

|

//2448
*  l assi_op1 ...;
?   s
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){
    ...
*   l assi_op2 ...
    ...
}else{
    ...
*   return retVal;
}


|
// **********
//  bd
// **********
if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){
    ...
*   l assi_op2 ...
    ...
*   return retVal;
}
?   s
*  l assi_op1 ...;

|

if (
    <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
)
    ...+>
    ){ ... }else{
    ...
*   l assi_op2 ...
    ...
*   return retVal;
}
?   s
*  l assi_op1 ...;





)

@script:python@
p << one_assign_and_return.p;
@@
print("hit:" + p[0].line)


@no_else@
// 省略else分支，true分支拥有自己的返回值和要做的事
expression l, e, retVal;
assignment operator op;
identifier bad_call;    //we don't want this
global idexpression cond =~ "[a-z]";
expression base, pointer =~ "[a-z]";
identifier fld;
global idexpression g =~ "[a-z]";
statement s;
position p;
@@
(
// filter if which has call in cond
/*
don't need for test
* if(<+... bad_call(...) ...+>){
    ...
}
|
* if(<+... bad_call(...) ...+>){
    ...
}else{
    ...
}

|

*/

if ( <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
) 
    ...+> ){
    ...
*   l = ...
    ...
*   return retVal;
}
?   s
*   l = ...;

|

// 提前了主路径赋值，之前pattern没有，不过在我看来是等效的
l = ...;
?   s
if ( <+... 
(   base@p -> fld \|   *pointer@p \|   g@p
) 
    ...+> ){
    ...
*   l = ...
    ...
*   return retVal;
}

)
@script:python@
p << no_else.p;
@@
print("hit:" + p[0].line)
