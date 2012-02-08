-module(json_test).
-export([encode/0, decode/0]).
-include_lib("../../jsonerl/src/jsonerl.hrl").
-record(test, {a, b, c}).

decode() ->
	A = jsonerl:encode("{a:1, b:2, c:3}"),
	Json = "{a:1, b:2, c:3}",
	B = ?json_to_record(test, A),
	io:format("~p ~n", [B]).

encode() ->
	A=#test{a=1, b=3, c=5},
	%A = jsonerl:encode("{a:1, b:2, c:3}"),
	B = ?record_to_json(test, A),
	io:format("~p ~n",[B]).
