@decl_union_return@
//  ifMultiCmp_gcc
global idexpression cond =~ "[a-z]";
identifier typeName;
identifier lvar;
@@
if ( <+...
*   cond ...+> ){
    ...
    union typeName lvar = {...};
    ...
    return lvar;
    ...
}

@script:python@
x << decl_union_return.cond;
@@
if len(x) != 0:
    print "#pat decl_union_return"
