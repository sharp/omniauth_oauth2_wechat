-module(merle_client).
-export([start/0, fetch/1, set/2]).

start() ->
  merle:connect().

set(K, V) -> 
  merle:set(K, V).

fetch(K) ->
  merle:getskey(K).
