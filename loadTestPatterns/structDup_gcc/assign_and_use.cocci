@assign_and_use@
expression struct s;
idexpression g;
position p;
@@

*   s = g
...
return s;

@script:python@
p << assign_and_use.p;
@@
print("hit:" + p[0].line)
