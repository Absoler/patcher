@union_assign@
//662
expression union u;
identifier f1, f2, f3;
expression e1, e2, e3;
global idexpression g;
@@
(
u.f1 = g[...][...];
|
u.f1 = g[...];
|
u.f1 = g;
)
...
if(...){
    ...
*   u.f2 = ...;
    ...
}
...
u.f3