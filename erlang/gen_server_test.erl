-module(gen_server_test).
-behaviour(gen_server).
-export([start_link/0]).
-export([alloc/0, free/1]).
-export([init/1, handle_call/3, handle_cast/2]).
start_link() ->
    gen_server:start_link({local, gen_server_test}, gen_server_test, [], []).

alloc() ->
    io:format("allocing\n"),
		gen_server:call(?MODULE, {alloc}).

free(Ch) ->
    gen_server:cast(gen_server_test, {free, Ch}).

init(_Args) ->
    {ok, channels()}.

handle_call({alloc}, _From, LoopData) ->
    Reply = io:format("handle alloc\n"),
		io:format("_From"),
	 	{reply, Reply, LoopData}.
	
handle_cast({free, Ch}, LoopData) ->
    io:format("handle cast \n"), 
		{noreply, Ch}.

terminate(shutdown, State) ->
    io:format("shutdown\n"),
		ok.
free() -> 
		io:format("free").

channels() ->
		io:format("channels").
