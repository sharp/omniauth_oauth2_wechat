-module(apns_sup).

-behaviour(supervisor).

-include("apns.hrl").

-export([start_link/0]).
-export([init/1]).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================
%% @hidden
-spec start_link() -> {ok, pid()} | ignore | {error, {already_started, pid()} | shutdown | term()}.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).
    
%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
%% @hidden
-spec init([]) ->  {ok, {{one_for_one, 5, 10}, [{connection, {apns_server, start_link, []}, transient, 5000, worker, [apns_server]}]}}.
init([]) ->
  io:format("apns sup start ... ~n"),
  ConfigFile = "/etc/sharp_pusher.conf",
  case file_exist(ConfigFile) of 
    true -> 
      ApnsConfig = file:consult(proplists:get_value(apns, ConfigFile));
    false -> 
      ApnsConfig = file:consult("priv/sharp_pusher.conf"),
      io:format("No config file")
  end,
  PoolArg = [{name, {local, apns_workers_pool}}, {worker_module, apns_worker}, {size, 5}, {max_overflow, 10}],

  PoolSpecs = poolboy:child_spec(apns_workers_pool, PoolArg, ApnsConfig),
  {ok, {{one_for_one, 5, 10}, [PoolSpecs]}}.

file_exist(Filename) ->
    case file:read_file_info(Filename) of
        {ok, _}         -> io:format("~s is found~n", [Filename]);
        {error, enoent} -> io:format("~s is missing~n", [Filename]);
        {error, Reason} -> io:format("~s is ~s~n", [Filename, Reason])
    end.

      