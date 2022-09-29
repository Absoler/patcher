@one_assign_and_other@
//  ifMultiCmp_gcc
// 71   一组对立的赋值，加上一个单独的后面会被用到的赋值
expression  l, other;
global idexpression cond =~ "[a-z]";
assignment operator op;
@@

(
*   if (<+... cond ...+>) {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
) 
    ...
} else {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
) 
    ...
*   other = ...
    ...
}
<+... other ...+>

|
*   if (<+... cond ...+>) {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
)
    ...
*   other = ...
    ...
} else {
    ...
(   l = ... \| l++ \| l-- \| ++l \| --l
)
    ...
}
<+... other ...+>
)

@script:python@
x << one_assign_and_other.cond;
@@
print x