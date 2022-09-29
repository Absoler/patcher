@div@
expression e1, e2, s=~"g_";
identifier f1, f2;
typedef uint64_t, int64_t;
@@
(
*  ( e1 || e2 ) / s.f1 + s.f2
|
*   1 / (int64_t) e1
|
*   1 / (uint64_t) e1
)