@assign_and_return@
//  ifMultiCmp_gcc
//2068
statement s;
global idexpression cond =~ "[a-z]";
expression e1, e2, e3, e4, lvar1 , lvar2 ;
expression struct es;
position p;
type t;
@@
if ( <+... 
*   cond@p ...+> ) {
    <+... 
*   lvar1 = e1 ...+>
*   return e3;
}
?   s
*   lvar1 = e2;
*   return e4;

@script:python@
p << assign_and_return.p;
x << assign_and_return.cond;
l << assign_and_return.lvar1;
@@
print "hit:" + p[0].line
#print "cond:    " + x
#print "lvar:   " + l
print ""