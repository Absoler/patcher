@load_retVal_inAdvance@
identifier func;
idexpression ret;
position p;
// 1041
@@
(

if(...){
    ...
(
    if(...){
        ...
        func(...)
        ...
    }
|
    if(...){
        ...
    }else{
        ...
        func(...)
        ...
    }
)
    ...
*   return <+... ret@p ...+>;
}

|

if(...){
    ...
}else{
    ...
(
    if(...){
        ...
        func(...)
        ...
    }
|
    if(...){
        ...
    }else{
        ...
        func(...)
        ...
    }
)
    ...
*   return <+... ret@p ...+>;
}

)

@script:python@
p << load_retVal_inAdvance.p;
@@
print "hit:" + p[0].line