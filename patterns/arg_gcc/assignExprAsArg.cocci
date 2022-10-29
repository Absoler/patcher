@assignExprAsArg@
/*
    for struct and union, may cause duplicate copy
*/
expression struct sExp;
expression union uExp;
expression l,r;
global idexpression  g;
assignment operator op;
identifier func;
position p;
//1682
@@
(
*  func(..., l op sExp@p, ...)
|
*  func(..., l op uExp@p, ...)
)

@script:python@
p << assignExprAsArg.p;
@@ 
print "hit:"+p[0].line