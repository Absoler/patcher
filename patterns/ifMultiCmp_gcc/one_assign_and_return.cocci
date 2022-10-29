@one_assign_and_return@
//  本pattern描述对一个live变量的赋值和返回值在不同分支效果不同的情况
// 如果是对相同变量的赋值，但使用了不相同的指针，那将无法辨认
expression l, e, retVal;
assignment operator op;
idexpression cond =~ "[a-z]", g;
statement s;
position p;
@@
(
// 3710 3549
if ( <+... 
*   cond@p ...+> ){
    ...
(   *l = ...    \|  l = ...
)
    ...
}else{
    ...
(   *l = ...    \|  l = ...
)
    ...
*   return retVal;
}

|
//衍生自上面的情况
if ( <+... 
*   cond@p ...+> ){
    ...
(   *l = ...    \|  l = ...
)
    ...
*   return retVal;
}else{
    ...
(   *l = ...    \|  l = ...
)
    ...
}

|
//下面赋值都是把赋值的一种情况提前
// 1059 2964
(   
*   *l = ... ;  
|  
*   l = ... ;
)
?   s
if ( <+... 
*   cond@p ...+> ){
    ...
    return retVal;
    ...
}
...
(   
*   *l = ...   
|  
*   l = ...
)

|
//107 3265
(   *l = ... ;   \|  l = ... ;
)
?   s
if ( <+... 
*   cond@p ...+> ){
    ...
(   *l = ...    \|  l = ...
)
    ...
*   return retVal;
    ...
}

|

//2448
(   *l = ... ;   \|  l = ...;
)
?   s
if (<+... 
*   cond@p ...+> ){
    ...
(   *l = ...    \|  l = ...
)
    ...
}else{
    ...
    return retVal;
}

)

@script:python@
cond << one_assign_and_return.cond;
l << one_assign_and_return.l;
g << one_assign_and_return.g;
p << one_assign_and_return.p;
@@
#print "cond: "+cond
#print "l: "+l
#print "g: "+g
print "hit:" + p[0].line
print ""