-module(gen_server_test).
-behaviour(gen_server).
-export([start/0, start_link/0]).
-export([alloc/0, alloc/1, free/1]).
-export([init/1, handle_call/3, handle_cast/2]).
start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).  
stop()  -> gen_server:call(?MODULE, stop). 
start_link() ->
    gen_server:start_link({local, gen_server_test}, gen_server_test, [], []).
alloc() ->
    io:format("allocing"),
		gen_server:call(gen_server_test, alloc).
free(Ch) ->
    gen_server:cast(gen_server_test, {free, Ch}).
init(_Args) ->
    {ok, channels()}.
handle_call(alloc, _From, Chs) ->
    io:format("handle alloc").
andle_cast({free, Ch}, Chs) ->
    io:format(Ch).
free() -> 
		io:format("free").
channels() ->
		io:format("channels").
alloc(chs) -> 
		io:format("alloc chs").
