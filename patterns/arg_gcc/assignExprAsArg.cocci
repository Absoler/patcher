@assignExprAsArg@
/*
    for struct and union, may cause duplicate copy
*/
expression struct sExp;
expression union uExp;
expression l,r;
global idexpression  g;
assignment operator op;
identifier func =~ "func";
@@
(
*  func(..., l op sExp, ...)
|
*  func(..., l op uExp, ...)
)