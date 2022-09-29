@struct_assign_and_if@
//1084
expression struct es;
expression e;
identifier f1, f2;
@@
es = e;
...
if ( <+... es.f1 || es.f2 ...+> ) {
    <+...
(
*   es.f1
|
*   es.f2
)
    ...+>
}