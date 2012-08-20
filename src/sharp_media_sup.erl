%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created : 31 Jul 2012 by sharp <sharp@sharp-Rev-1-0>

-module(sharp_media_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_link/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    log4erl:info("Start sharp media sup ..."),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_link([media_resources]) ->
    supervisor:start_link({local, media_resources_sup}, ?MODULE, [media_resources]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([media_resources]) ->
    MediaResource =  ?CHILD(media_resources, worker),
    {ok, { {simple_one_for_one, 5, 10}, [MediaResource]} };

init([]) ->
    MQ = ?CHILD(sharp_media_mq, worker),
    ENGINE = ?CHILD(sharp_media_engine, worker),
    {ok, { {one_for_one, 5, 10}, [ENGINE, MQ]} }.
