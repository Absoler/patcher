@parm_deref_assign@
//2054 1786 s可以是和其余变量无关的global赋值等语句 3801不需要 O2似乎无效
identifier id , func;
expression e1,e2;
global idexpression cond;
type t;
statement s;
position p;
@@
func(..., t id ,...){
...
    *id = e1
...
s

(
if ( <+... cond ...+> ) {
    ...
} else {
    <+... 
*   *id = e2@p ...+>
}

|

if ( <+... cond ...+> ) {
    <+... 
*   *id = e2@p ...+>
} else {
    ...
}

|

if ( <+... cond ...+> ) {
    <+... 
*   *id = e2@p ...+>
} 
)
...
}

@script:python@
cond << parm_deref_assign.cond;
id << parm_deref_assign.id;
p << parm_deref_assign.p;
@@
#print "cond:    " + cond
print "id:  " + id
print "hit:" + p[0].line