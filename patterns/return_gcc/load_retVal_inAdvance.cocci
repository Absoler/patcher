identifier func =~ "func";
global idexpression ret;

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
*   return <+... ret ...+>;
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
*   return <+... ret ...+>;
}

)