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
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_link([hds]) ->
    supervisor:start_link({local, media_handler}, ?MODULE, [sharp_hds]);
start_link([hls]) ->
	  supervisor:start_link({local, media_handler}, ?MODULE, [sharp_hls]).


%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([hds]) ->
    {ok, { {simple_one_for_one, 5, 10}, [sharp_hds]} };

init([hls]) ->
		{ok, { {simple_one_for_one, 5, 10}, [sharp_hls]} };

init([]) ->
    MQ = ?CHILD(sharp_media_mq, worker),
    MediaHandler =  ?CHILD(media_handler, worker),
    RequestHandler = ?CHILD(request_handler, worker),
    {ok, { {one_for_one, 5, 10}, [MQ, RequestHandler]} }.
