@struct_useAfterAssign@
//1026
expression struct es;
expression l, r;
identifier f;
@@
...
l = es
...
*   l.f
...
es = l