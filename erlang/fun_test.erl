-module(fun_test).
-export([run/0]).
-record(frame, {a=1, b, c}).
-define(D(X), io:format("~p~n", [X])).

run() ->
    fun1({1,2,3}),
    fun2(#frame{a=2, b=hello, c="world"}).

fun2(#frame{a=A, b = B, c =C}) ->
    ?D({A, B, C}).

fun1({_, _, x} = State) ->
    ?D(x);
fun1({A} = State) ->
    ?D(A);
fun1({1, _, Y} = State) ->
    ?D(Y),
    ?D(State).
