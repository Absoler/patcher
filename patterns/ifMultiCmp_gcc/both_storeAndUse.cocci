@two_things@
//ifMultiCmp_gcc
//1054 3242
idexpression cond =~ "[a-z]", g1, g2;
expression l1, l2, r1, r2;
assignment operator op1, op2, op3, op4;
position p;
//严格限制后续使用必须是紧邻语句的if-cond、return、赋值给global
@@
if(<+...
*   cond@p ...+>){
    ...
(   
    l1 op1 r1   \|     l1++ \| ++l1    \|   l1-- \| --l1
)
    ...
(   l2 op2 r2   \|  l2++ \| ++l2    \| l2-- \| --l2
)
    ...
}
(

(
*   if(<+... l1 ...+>){
        ...
    }
|
*   if(<+... l1 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l1 ...+>;
|
    (<+... 
*   g1 ...+>) op3 l1; 
|
*   callee(..., l1, ...);
)

(
*   if(<+... l2 ...+>){
        ...
    }
|
*   if(<+... l2 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l2 ...+>;
|
    (<+...
*   g2 ...+>) op4 l2; 
|
*   callee(..., l2, ...);
)

|

(
*   if(<+... l2 ...+>){
        ...
    }
|
*   if(<+... l2 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l2 ...+>;
|
    (<+...
*   g2 ...+>) op4 l2;
|
*   callee(..., l2, ...); 
)

(
*   if(<+... l1 ...+>){
        ...
    }
|
*   if(<+... l1 ...+>){
        ...
    }else{
        ...
    }
|
*   return <+... l1 ...+>;
|
    (<+... 
*   g1 ...+>) op3 l1; 
|
*   callee(..., l1, ...); 
)

)

@script:python@
p << two_things.p;
x << two_things.cond;
l1 << two_things.l1;
l2 << two_things.l2;
@@
print "hit:" + p[0].line
#print " cond: " + x
#print " l1: " + l1
#print " l2: " + l2
print ""