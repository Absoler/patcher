@assign_struct_and_use@
//  ifMultiCmp_gcc
identifier typeName, lvar;
global idexpression cond =~ "[a-z]";
expression struct other;
@@
(
if( <+... cond ...+> ) {
    ...
*   struct typeName lvar = {...} ;
    ...
    lvar
    ...
} else { ... 
*   other ...}

|

if( <+... cond ...+> ) {
    ...
(
*   struct typeName lvar = ... ;
|
*   struct typeName lvar[...] = ... ;
|
*   struct typeName lvar[...][...] = ... ;
)
    ...
    lvar
    ...
} 
... 
*   other 
...

|
//140 只要if-branch中返回struct

if ( <+... cond ...+> ){
...
*   return other ; 
...    
}
...


|
//1046
if ( <+... 
*   cond ...+> ){
    ...
*   lvar = ...;
    ...
}
...
*   lvar.f1
...
*   lvar.f2

)

@script:python@
x << assign_struct_and_use.cond;
@@
if len(x) != 0:
    print "#pat assign_struct_and_use"