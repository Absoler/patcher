@struct_useAfterAssign@
/*
    boring
    example: 1026
*/
expression struct es;
expression l, r;
identifier f;
position p1, p2;
@@
...
l = es@p1
...
*   l.f@p2
...
es = l

@script:python@
p1 << struct_useAfterAssign.p1;
p2 << struct_useAfterAssign.p2;
@@
print "hit:" + p1[0].line + " " + p2[0].line