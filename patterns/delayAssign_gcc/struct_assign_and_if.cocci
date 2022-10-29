@struct_assign_and_if@
//1084
expression struct es;
expression e;
identifier f1, f2;
position p1, p2;
@@
es = e;
...
if ( <+... es.f1 || es.f2@p1 ...+> ) {
    <+...
(
*   es.f1@p2
|
*   es.f2@p2
)
    ...+>
}

@script:python@
p1 << struct_assign_and_if.p1;
p2 << struct_assign_and_if.p2;
@@
print "hit:" + p1[0].line + " " + p2[0].line