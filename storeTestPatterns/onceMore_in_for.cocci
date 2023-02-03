@target_func@
identifier func =~ "^func";
statement anything;
type t;
@@
t  func(...){
    ...
}

@forLoop depends on target_func@
statement anything;
identifier target_func.func;
expression init, cond, incr;
@@
func(...){
    <+... 
    for(...;cond;incr)
*       anything
    ...+>
}