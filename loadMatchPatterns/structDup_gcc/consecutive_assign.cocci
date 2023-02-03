@consecutive_assign@
expression struct lval, rval, mid;
expression union lu, mu, ru;
identifier a,b,c;
position p;
@@
// also work with union
(
*   lval = mid = rval@p
|
*   lu = mu = ru@p
)
@script:python@
p << consecutive_assign.p;
@@
print("hit:" + p[0].line)
