@Assign_with_logic@
identifier func =~ "func";
global idexpression g;
expression e1,e2;
@@
(
* func(..., <+... <+... g ...+> || <+... e1 = e2 ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2 ...+> || <+... g ...+> ...+> ,...)
|
* func(..., <+... <+... g ...+> && <+... e1 = e2 ...+> ...+> ,...)  \|
* func(..., <+... <+... e1 = e2 ...+> && <+... g ...+> ...+> ,...) 
)