@union_assignExpr_arg@
expression union rval;
identifier l, func, fld;
@@
*   func( <+... l = rval@p1 ...+> ) 
...
l.fld@p2

@script:python@
p1 << struct_useAfterAssign.p1;
p2 << struct_useAfterAssign.p2;
@@
print "hit:" + p1[0].line + " " + p2[0].line