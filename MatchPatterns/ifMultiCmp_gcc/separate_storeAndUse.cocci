@separate_storeAndUse@
//  ifMultiCmp_gcc
//142, 在if两个分支中各做一件事，并且之后会用到它
global idexpression cond =~ "[a-z]", g1, g2;
expression l1, l2, r1, r2;
position p;
assignment operator op1, op2, op3, op4;
identifier callee;
@@

if (<+...
*   cond@p ...+>){
    ...
(
    l1 op1 r1 \| l1++ \| l1-- \| ++l1 \| --l1
)
    ...
}else{
    ...
(
    l2 op2 r2 \| l2++ \| l2-- \| ++l2 \| --l2
)
    ...
}

(

// use l1, l2
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

// use l2, l1
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
p << separate_storeAndUse.p;
x << separate_storeAndUse.cond;
l << separate_storeAndUse.l1;
r << separate_storeAndUse.l2;
@@
print "hit:" + p[0].line
#print "cond: "+x
#print "l1: "+l
#print "l2: "+r
print ""