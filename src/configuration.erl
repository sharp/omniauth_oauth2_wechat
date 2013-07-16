
-module(configuration).

-behaviour(gen_server).

-export([start_link/0, get_apns_host/0, get_apns_port/0, get_cert_file/1, get_apns_timeout/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

init([]) ->
	case os:getenv("mode") of
		"development" -> 
			{ok, ConfigFile} = load_config_file("priv/sharp_pusher.conf"),
			Config = proplists:get_value(development, ConfigFile);
		false -> 
			{ok, ConfigFile} = load_config_file("/etc/sharp_pusher.conf"),
			Config = proplists:get_value(production, ConfigFile)
		end,
    {ok, Config}.

load_config_file(Path) ->
	case file_exist(Path) of 
        true -> 
            file:consult(Path);
        false -> 
            io:format("No config file found in /etc/sharp_pusher.conf")
	end.

file_exist(Filename) ->
    case file:read_file_info(Filename) of
        {ok, _}         -> io:format("~s is found~n", [Filename]), true;
        {error, enoent} -> io:format("~s is missing~n", [Filename]), false;
        {error, Reason} -> io:format("~s is ~s~n", [Filename, Reason]), false
    end.


get_apns_host() ->
	gen_server:call(?MODULE, get_apns_host).

get_apns_port() ->
	gen_server:call(?MODULE, get_apns_port).

get_cert_file(App) -> 
	gen_server:call(?MODULE, {get_cert_file, App}).

get_apns_timeout() ->
	gen_server:call(?MODULE, get_apns_timeout).

handle_call(get_apns_host, _From, Config) ->
    Host = proplists:get_value(apns_host, Config),
    {reply, Host, Config};

handle_call(get_apns_port, _From, Config) ->
    Port = proplists:get_value(apns_port, Config),
    {reply, Port, Config};

handle_call({get_cert_file, App}, _From, Config) ->
    Certificates = proplists:get_value(certificates, Config),
    Cert = proplists:get_value(App, Certificates),
    {reply, Cert, Config};

handle_call(get_apple_host, _From, Config) ->
    Timeout = proplists:get_value(timeout, Config),
    {reply, Timeout, Config}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

	