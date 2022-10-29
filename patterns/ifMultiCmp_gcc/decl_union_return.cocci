@decl_union_return@
//  ifMultiCmp_gcc
global idexpression cond =~ "[a-z]";
identifier typeName;
identifier lvar;
position p;
@@
if ( <+...
*   cond@p ...+> ){
    ...
    union typeName lvar = {...};
    ...
    return lvar;
    ...
}

@script:python@
x << decl_union_return.cond;
p << decl_union_return.p;
@@
print "hit:" + p[0].line
