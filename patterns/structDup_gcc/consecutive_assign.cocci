@consecutive_assign@
expression struct lval, rval, mid;
expression union lu, mu, ru;
identifier a,b,c;
@@
// also work with union
(
*   lval = mid = rval
|
*   lu = mu = ru
)