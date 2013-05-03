
-module(mqtt_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%% ===================================================================
%% API functions
%% ===================================================================
%% @hidden
-spec start_link() -> {ok, pid()} | ignore | {error, {already_started, pid()} | shutdown | term()}.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
  io:format("start mqtt ... ~n "),
  ignore.


      