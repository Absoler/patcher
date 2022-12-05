@target_func@
identifier func =~ "^func";
statement anything;
type t;
@@
*  func(...){
    ...
}

@forLoop depends on target_func@
statement anything;
identifier target_func.func;
@@
func(...){
    ...
    for(...;...;...)
*       anything
    ...
}