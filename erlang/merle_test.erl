-module(merle_test).
-export([start/0, fetch/1, set/2]).

start() ->
  ok.

set(K, V) -> 
  merle_client:set(K, V).

fetch(K) ->
  merle_client:fetch(K).
