@compound_assign@
//  ifMultiCmp_gcc
//103 the rhs is an incr/decr
global idexpression cond =~ "[a-z]";
expression rval, l;

@@
if ( <+...
*   cond ...+>){
    ...
(
    l = rval++
|
    l = rval--
)
    ...
}
...
rval
...

@script:python@
x << compound_assign.cond;
@@
if len(x) != 0:
    print "#pat compound_assign"