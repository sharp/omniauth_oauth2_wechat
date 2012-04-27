%%%-------------------------------------------------------------------
%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created : 26 Apr 2012 by sharp <sharp@sharp-Rev-1-0>
%%%-------------------------------------------------------------------
-module(fun_test).

-export([start_link/0, init/1]).
-export([start_link/1, run/0]).
-record(frame, {a=1, b, c}).
-define(D(X), io:format("~p~n", [X])).

start_link() ->
    ?D(2),
    spawn(fun_test, init, [self()]).

start_link(A) ->
    ?D(2),
    ?D(A),
    spawn(fun_test, init, [self()]).

init(From) ->
    loop(From).

loop(From) ->
    ?D(ok),
    timer:sleep(2000),
    loop(From).

run() ->
    fun1({1,2,3}),
    fun2(#frame{a=2, b=hello, c="world"}),
    timer:sleep(2000),
    run().

fun2(#frame{a=A, b = B, c =C}) ->
    ?D({A, B, C}).

fun1({_, _, x} = State) ->
    ?D(x);
fun1({A} = State) ->
    ?D(A);
fun1({1, _, Y} = State) ->
    ?D(Y),
    ?D(State).
