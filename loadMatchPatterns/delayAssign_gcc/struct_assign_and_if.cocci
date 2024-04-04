@struct_assign_and_if@
/*
    example: 1084 load

    gcc-12.1 -O1

    struct S6 {
        short  f0;
        char  f1;
        int  f2;
    };
    void func_30() {
        struct S6 f[4][7];
        f[1][6] = g_36;
        if (f[1][6].f0 || f[1][6].f1)
            g_48 = f[1][6].f1;
    }

    0000000000401186 <func_30>:
    func_30():
    /home/csmith-2.3.0/test/output2.c:36
    401186:	48 83 ec 70          	sub    $0x70,%rsp
    /home/csmith-2.3.0/test/output2.c:39
    40118a:	f7 05 d4 2e 00 00 ff 	testl  $0xffffff,0x2ed4(%rip)        # 404068 <g_36>
    401191:	ff ff 00 
    401194:	74 0d                	je     4011a3 <func_30+0x1d>
    /home/csmith-2.3.0/test/output2.c:40
    401196:	0f be 05 cd 2e 00 00 	movsbl 0x2ecd(%rip),%eax        # 40406a <g_36+0x2>
    40119d:	89 05 bd 2e 00 00    	mov    %eax,0x2ebd(%rip)        # 404060 <g_48>
    /home/csmith-2.3.0/test/output2.c:41
    4011a3:	48 83 c4 70          	add    $0x70,%rsp
    4011a7:	c3                   	retq   

*/
expression struct es;
expression union eu;
expression e;
identifier f1, f2;
position p1, p2;
@@
(
    
es = e;
...
if ( <+... es.f1 || es.f2@p1 ...+> ) {
    <+...
*   es.f1@p2
    ...+>
}

|

es = e;
...
if ( <+... es.f2 || es.f1@p1 ...+> ) {
    <+...
*   es.f1@p2
    ...+>
}

|

eu = e;
...
if ( <+... eu.f1 || eu.f2@p1 ...+> ) {
    <+...
*   eu.f1@p2
    ...+>
}

|

eu = e;
...
if ( <+... eu.f2 || eu.f1@p1 ...+> ) {
    <+...
*   eu.f1@p2
    ...+>
}

)

@script:python@
p1 << struct_assign_and_if.p1;
p2 << struct_assign_and_if.p2;
eu << struct_assign_and_if.eu = "";
es << struct_assign_and_if.es = "";
f1 << struct_assign_and_if.f1 = "";
f2 << struct_assign_and_if.f2 = "";
@@
print("hit:" + p1[0].line + " " + p2[0].line)
target = es if es else eu
target += ("." + f1 if f1 else f2)
print("target: " + target)