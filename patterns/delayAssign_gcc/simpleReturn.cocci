@simpleReturn@
expression lhs, rval;
assignment operator op;
statement s;
position p1, p2;
@@

lhs@p1 op rval;
?s
*   return lhs@p2;

@script:python@
n << simpleReturn.lhs;
p1 << simpleReturn.p1;
p2 << simpleReturn.p2;
@@
print "hit:" + p1[0].line + " " + p2[0].line