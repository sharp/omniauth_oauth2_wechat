-module(apns_worker).
-behaviour(gen_server).
-behaviour(poolboy_worker).

-include("apns.hrl").

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {ssl_socket        :: tuple(),
                apns_config        :: #apns_config{},
                in_buffer = <<>>  :: binary(),
                out_buffer = <<>> :: binary()}).

start_link(Args) ->
    gen_server:start_link(?MODULE, Args, []).

init(Args) ->
    Config = proplists:get_value(development, Args),
    ApnsConfig = #apns_config{
        apple_host = proplists:get_value(apple_host, Config),
        apple_port = proplists:get_value(apple_port, Config),
        cert_file = proplists:get_value(cert_file, Config)
    },
    io:format("apns worker is starting ~p ~n", [ApnsConfig]),
    {ok, SslSocket} = open_connection(ApnsConfig),
    {ok, #state{apns_config=ApnsConfig, ssl_socket=SslSocket}}.

handle_call({send, Req}, _From, #state{ssl_socket=SslSocket}=State) ->
    is_open(SslSocket),
    {reply, apns:send(Req, SslSocket), State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #state{apns_config=Config}) ->
    ok = pgsql:close(Config),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

is_open(SslSocket) ->
    case ssl:peername(SslSocket) of 
        {ok, _} -> "";
        {error, _} -> open_connection
    end.

open_connection(ApnsConfig) ->
  KeyFile = case ApnsConfig#apns_config.key_file of
    undefined -> [];
    Filename -> [{keyfile, filename:absname(Filename)}]
  end,
  SslOpts = [
    {certfile, filename:absname(ApnsConfig#apns_config.cert_file)},
    {mode, binary} | KeyFile
  ],
  RealSslOpts = case ApnsConfig#apns_config.cert_password of
    undefined -> SslOpts;
    Password -> [{password, Password} | SslOpts]
  end,
  case ssl:connect(
    ApnsConfig#apns_config.apple_host,
    ApnsConfig#apns_config.apple_port,
    RealSslOpts,
    ApnsConfig#apns_config.timeout
  ) of
    {ok, Socket} -> {ok, Socket};
    {error, Reason} -> {error, Reason}
  end.


