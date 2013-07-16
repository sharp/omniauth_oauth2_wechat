-module(sharp_pusher_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    io:format("sharp pusher server has started ~n"),
    sharp_pusher_sup:start_link(),
    init_webserver().

init_webserver() ->
    Dispatch = cowboy_router:compile([
        %% {URIHost, list({URIPath, Handler, Opts})}
        {'_', [{"/apns/:app", apns_handler, []}]},
        {'_', [{"/tokens/:token", tokens_handler, []}]}
    ]),
    %% Name, NbAcceptors, TransOpts, ProtoOpts
    cowboy:start_http(sharp_http_listener, 100, [{port, 8080}], [{env, [{dispatch, Dispatch}]}]
).

stop(_State) ->
    ok.
