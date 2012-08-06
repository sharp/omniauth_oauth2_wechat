-module(sharp_media_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    start(normal, []).

start(_StartType, _StartArgs) ->
    application:start(pooly),
    application:start(log4erl),
    log4erl:conf("priv/log4erl.conf"),
    application:start(cowboy),
    Dispatch = [
		%% {Host, list({Path, Handler, Opts})}
		{'_', [{'_', http_handler, []}]}
	       ],
    %% Name, NbAcceptors, Transport, TransOpts, Protocol, ProtoOpts
    cowboy:start_listener(my_http_listener, 100,
			  cowboy_tcp_transport, [{port, 8080}],
			  cowboy_http_protocol, [{dispatch, Dispatch}]
			 ),
    load_config(),
    sharp_media_sup:start_link().

load_config() ->
    {ok, Config} = file:cosult("sharp_media.conf"),
    application:set_env(sharp_media, app_config, Config).
    

stop(_State) ->
    ok.
