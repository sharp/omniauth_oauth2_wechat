%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created : 23 Jul 2012 by sharp <sharp@sharp-Rev-1-0>

-module(http_handler).
-export([init/3, handle/2, terminate/2]).

init({tcp, http}, Req, Opts) ->
    log4erl:debug("~p~n", [Opts]),
    {ok, Req, undefined_state}.

handle(Req, State) ->
    {Method, Req2} = cowboy_http_req:method(Req),
    {HasBody, Req3} = cowboy_http_req:has_body(Req2),
    {ok, Req4} = process(Method, HasBody, Req3),
    {ok, Req4, State}.

process('POST', true, Req) ->
    {PostVals, _} = cowboy_http_req:body_qs(Req),
    URL = proplists:get_value(<<"url">>, PostVals),
    io:format("~p~n", [URL]),
    cowboy_http_req:reply(200, [{<<"Content-Encoding">>, <<"utf-8">>}], "OK", Req);

process('POST', false, Req) ->
    cowboy_http_req:reply(400, [], <<"Missing body.">>, Req);

process(_, _, Req) ->
    %% Method not allowed.
    cowboy_http_req:reply(405, Req).

terminate(Req, State) ->
    log4erl:debug("~p~p~n", [Req, State]),
    ok.


