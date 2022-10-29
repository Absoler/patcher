@compound_assign@
//  ifMultiCmp_gcc
//103 the rhs is an incr/decr
idexpression cond =~ "[a-z]";   //表示含有小写字母，防止匹配到宏
expression rval, l, other;
position p;
@@
if ( <+...
*   cond@p ...+>){
    ...
(
    l = rval++
|
    l = rval--
)
    ...
}
other = <+... rval ...+>;

@script:python@
x << compound_assign.cond;
p << compound_assign.p;
@@
print "hit:" + p[0].line