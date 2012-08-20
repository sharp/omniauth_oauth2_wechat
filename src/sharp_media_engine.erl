%%%-------------------------------------------------------------------
%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created :  6 Aug 2012 by sharp <sharp@sharp-Rev-1-0>
%%%-------------------------------------------------------------------
-module(sharp_media_engine).

-export([start_link/0, init/1]).

start_link() ->
    log4erl:info("Start sharp media engine ..."),
    start().

start() ->
    init([self()]).

init(From) ->
    loop(From).

loop(From) ->
    log4erl:info("Get request from MQ"),
    timer:sleep(3000),
    loop(From).
	
