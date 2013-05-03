-module(sharp_pusher).

%% API.
-export([start/0]).

start() ->
    ok = application:start(crypto),
    ok = application:start(sasl),
    ok = application:start(public_key),
    ok = application:start(ssl),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(sharp_pusher).
