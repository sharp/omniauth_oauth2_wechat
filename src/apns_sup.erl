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
-spec init(_) ->  {ok, {{one_for_one, 5, 10}, [{connection, {apns_server, start_link, []}, transient, 5000, worker, [apns_server]}]}}.
init(_) ->
  ConfigFile = "/etc/sharp_pusher.conf",
  case filelib:is_file(ConfigFile) of 
    true -> 
      ApnsConfig = File:consult(ConfigFile);
    false -> 
      ApnsConfig = File:consult("priv/sharp_pusher.conf"),
      io:format("No config file")
  end

  PoolSpecs = poolboy:child_spec(apns_workers_pool, [{size, 5}, {max_overflow, 10}], ApnsConfig),
  
  {ok,
    {{one_for_one, 5, 10}, PoolSpecs}
  }.


      