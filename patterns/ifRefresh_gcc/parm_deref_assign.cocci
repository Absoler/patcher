@parm_deref_assign@
//2054 1786 s可以是和其余变量无关的global赋值等语句 3801不需要
identifier id , func;
expression e1,e2;
global idexpression cond;
type t;
statement s;
@@
func(..., t id ,...){
...
*   *id = e1
...
s
(
if ( <+... cond ...+> ) {
    ...
} else {
    <+... 
*   *id = e2 ...+>
}

|

if ( <+... cond ...+> ) {
    <+... 
*   *id = e2 ...+>
} else {
    ...
}

|

if ( <+... cond ...+> ) {
    <+... 
*   *id = e2 ...+>
} 
)
...
}

@script:python@
cond << parm_deref_assign.cond;
id << parm_deref_assign.id;
@@
print "cond:    " + cond
print "id:  " + id