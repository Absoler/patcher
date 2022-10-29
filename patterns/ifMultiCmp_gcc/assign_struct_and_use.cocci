@assign_struct_and_use@
//  ifMultiCmp_gcc
identifier typeName, lvar;
idexpression cond =~ "[a-z]";
expression struct other;
position p;
@@
(

//1023 1035 1117 ...
if( <+... 
*   cond@p ...+> ) {
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
*   return other ;
|
if( <+... 
*   cond@p ...+> ) {
    ...
*   struct typeName lvar = {...} ;
    ...
    lvar
    ...
} else { 
    ...
*   return other;
}

|
//140 只要if-branch中返回struct

if ( <+... 
*   cond@p ...+> ){
...
*   return other ; 
...    
}


|
//1046
if ( <+... 
*   cond@p ...+> ){
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
p << assign_struct_and_use.p;
@@
print "hit:" + p[0].line