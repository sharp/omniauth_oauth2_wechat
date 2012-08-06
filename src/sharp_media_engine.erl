%%%-------------------------------------------------------------------
%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created :  6 Aug 2012 by sharp <sharp@sharp-Rev-1-0>
%%%-------------------------------------------------------------------
-module(sharp_media_engine).

-export([start/0, init/1]).


start() ->
    spawn_link(sharp_media_file, init, [self()]).

init(From) ->
    loop(From).

loop(From) ->
    {ok, HLS} = pooly:idle_count(hls_poor), 
    {ok, HDS} = pooly:idle_count(hds_pool),
    if
	(HLS > 0) and (HDS > 0) ->
	    {ok, _HdsProcess} = pooly:check_out(),
	    {ok, _HlsProcess} = pooly:checkout(),
	    case sharp_mq:get_request() of
		{ok, Req} ->	
		    log4erl:info([Req]);
		{error, Reason} ->
		    log4erl:error([Reason])
	    end;
	true ->
	    log4erl:warn("No idle process hls:~p hds~p", [HLS, HDS])
    end,
    timer:sleep(3000),
    loop(From).
	
