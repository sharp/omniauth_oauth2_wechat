-module(tokens_handler).
-behaviour(cowboy_http_handler).
 
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
 

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {Method, Req2} = cowboy_req:method(Req),
    HasBody = cowboy_req:has_body(Req2),
    {ok, Req3} = process(Method, HasBody, Req2),
    {ok, Req3, State}.

process(<<"POST">>, true, Req) ->
    {ok, PostVals, Req2} = cowboy_req:body_qs(Req),
    io:format("~p", [PostVals]),
    {Token, Req3} = cowboy_req:binding(token, Req2),
    poolboy:transaction(apns_workers_pool, fun(Worker) -> gen_server:call(Worker, {create, Token}) end),
    reply("success", Req3);

process(<<"POST">>, false, Req) ->
    cowboy_req:reply(400, [], <<"Missing body.">>, Req);

process(_, _, Req) ->
    %% Method not allowed.
    cowboy_req:reply(405, Req).

reply(undefined, Req) ->
    cowboy_req:reply(400, [], <<"Missing echo parameter.">>, Req);

reply(Rep, Req) ->
    cowboy_req:reply(200, [{<<"content-encoding">>, <<"utf-8">>}], Rep, Req).

terminate(_Reason, _Req, _State) ->
    ok.
