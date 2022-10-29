@one_assign_and_other@
//  ifMultiCmp_gcc
// 71   一组对立的赋值，加上一个单独的后面会被用到的赋值 1070 只有这俩
//if (g_31[0][1][5]) {
//    *b = 5;
//    d = 0;
//  } else
//    *b = 0;
//  g_66 = d;
// 最好分支里不要有太复杂的成分，不然容易按分支去翻译而不是直接比较后赋值
expression  l, other, retVal;
idexpression cond =~ "[a-z]";
assignment operator op;
position p;
identifier bad_call;    //we don't want this
@@

(
// filter these two
if(<+... bad_call(...) ...+>){
    ...
}
|
if(<+... bad_call(...) ...+>){
    ...
}else{
    ...
}

|

*   if (<+... cond@p ...+>) {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
) 
    ... when != return retVal;
} else {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
) 
    ...
*   other = ...
    ... when != return retVal;
}
<+... other ...+>

|
*   if (<+... cond@p ...+>) {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
)
    ... 
*   other = ...
    ... when != return retVal;
} else {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
)
    ... when != return retVal;
}
<+... other ...+>
)

@script:python@
x << one_assign_and_other.cond;
p << one_assign_and_other.p;
@@
print "hit:"+p[0].line
#cocci.print_sec(p[0], "sec")