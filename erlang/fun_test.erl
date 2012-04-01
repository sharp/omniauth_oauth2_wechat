-module(fun_test).
-export([test/0]).
-define(D(X), io:format("~p~n", [X])).

test() ->
    myfun({1,2,3}).

myfun({_, _, x} = State) ->
    ?D(x);
myfun({A} = State) ->
    ?D(A);
myfun({1, _, Y} = State) ->
    ?D(Y),
    ?D(State).

