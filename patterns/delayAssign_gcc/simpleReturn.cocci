@simpleReturn@
expression lhs =~ "g_", rval;
assignment operator op;
statement s;
@@

lhs op rval;
?s
*   return lhs;

@script:python@
n << simpleReturn.lhs;
@@
print n