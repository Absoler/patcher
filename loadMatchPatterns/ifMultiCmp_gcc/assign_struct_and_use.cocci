@assign_struct_and_use@
//  ifMultiCmp_gcc
identifier typeName, lvar;
identifier f1, f2;
global idexpression cond =~ "[a-z]";
expression struct other;
position p;
assignment operator assi_op1;
@@
(


/*
    example: 1117 
    gcc-12.1

    if (g_145.f4) {
        struct S3 c = {7, 9};
        return c;
    }
    return a[1];

    /home/csmith-2.3.0/test/output2.c:162
        401192:	0f b7 35 2f 56 00 00 	movzwl 0x562f(%rip),%esi        # 4067c8 <g_145+0x28>
        401199:	66 f7 de             	neg    %si
        40119c:	18 c9                	sbb    %cl,%cl
        40119e:	83 e1 07             	and    $0x7,%ecx
        4011a1:	0f b7 35 20 56 00 00 	movzwl 0x5620(%rip),%esi        # 4067c8 <g_145+0x28>
        4011a8:	66 f7 de             	neg    %si
        4011ab:	66 19 d2             	sbb    %dx,%dx
        4011ae:	83 e2 09             	and    $0x9,%edx

    //1023 1035 1117
*/
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
(
    return lvar;
|
    return lvar[...];
|
    return lvar[...][...];
)
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

/*
    example: 140
    //只要if-branch中返回struct

    struct S0 func_1() {
        if (g_18)
            return g_21;
        return g_25;
    }

    0000000000401196 <func_1>:
    func_1():
    /home/csmith-2.3.0/test/output2.c:111
    401196:	48 89 f8             	mov    %rdi,%rax
    /home/csmith-2.3.0/test/output2.c:114
    401199:	48 83 3d 07 9b 00 00 	cmpq   $0x1,0x9b07(%rip)        # 40aca8 <g_18>
    4011a0:	01 
    4011a1:	19 ff                	sbb    %edi,%edi
    4011a3:	66 81 e7 c7 38       	and    $0x38c7,%di
    4011a8:	66 81 ef c4 63       	sub    $0x63c4,%di
    4011ad:	48 83 3d f3 9a 00 00 	cmpq   $0x1,0x9af3(%rip)        # 40aca8 <g_18>
    4011b4:	01 
    4011b5:	19 f6                	sbb    %esi,%esi
    4011b7:	81 e6 6c e6 f1 95    	and    $0x95f1e66c,%esi
    4011bd:	81 ee 28 b1 90 55    	sub    $0x5590b128,%esi
    ...
    
*/


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
*   lvar assi_op1 ...;
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