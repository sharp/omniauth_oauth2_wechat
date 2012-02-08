%%%-------------------------------------------------------------------
%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created :  8 Feb 2012 by sharp <sharp@sharp-Rev-1-0>
%%%-------------------------------------------------------------------
-module(mnesia_test).

-export([start/0, init/0, create/1, find/1, delete/1]).

-record(plan, {name, age}).

start() ->
    mnesia:start(),
    init().

init() ->
    case mnesia:create_schema([node()]) of
	ok ->
	    ok;
	_ ->
	    "schema exist"
    end,
    case mnesia:create_table(plan, []) of
	{atomic, ok} ->
	    ok;
	_ ->
	    "table exist"
    end.

find(Name) ->
    mnesia:transaction(fun()->mnesia:read(plan, Name) end).

create({Name, Age}) ->
    mnesia:transaction(fun()->mnesia:write(#plan{name=Name, age=Age}) end).

delete(Name) ->
    mnesia:delete(plan, Name).
