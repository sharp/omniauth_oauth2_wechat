-module(apns_worker).
-behaviour(gen_server).
-behaviour(poolboy_worker).

-include("apns.hrl").

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%-record(state, {}).

start_link(Arg) ->
    gen_server:start_link(?MODULE, Arg, []).

init(_Arg) ->
    ConnectionsTab = ets:new(ssl_connections, [set]),
    {ok, {ConnectionsTab}}.

handle_call({notification, App, Msg}, _From, State) ->
    {ConnectionsTab} = State,
    case ets:lookup(ConnectionsTab, App) of
        [Connection] -> 
            apns:send(Connection, App, Msg);
        _ -> 
            Connection = open_connection(App),
            ets:insert(ConnectionsTab, {App, Connection}),
            apns:send(Connection, App, Msg)
        end,
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

open_connection(App) ->
    SslOpts = [
        {certfile, filename:absname(configuration:get_cert_file(App))},
        {mode, binary} 
    ],
    case ssl:connect(
        configuration:get_apns_host(),
        configuration:get_apns_port(),
        SslOpts,
        configuration:get_apns_timeout()
    ) of
        {ok, Socket} -> {ok, Socket};
        {error, Reason} -> {error, Reason}
    end.


