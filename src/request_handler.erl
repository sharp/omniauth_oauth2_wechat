%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created : 23 Jul 2012 by sharp <sharp@sharp-Rev-1-0>

-module(request_handler).
-export([init/3, handle/2, terminate/2]).

init({tcp, http}, Req, Opts) ->
    log4erl:debug("~p~n", [Opts]),
    {ok, Req, undefined_state}.

handle(Req, State) ->
    {Method, Req2} = cowboy_http_req:method(Req),
    {HasBody, Req3} = cowboy_http_req:has_body(Req2),
    io:format("REQ is ~p ~p ~p ~n", [Req==Req2, Req==Req2, Req==Req3]),
    {ok, Req4} = process(Method, HasBody, Req3),
    
    {ok, Req4, State}.

process('POST', true, Req) ->
    %ContentType = cowboy_http_req:parse_header(<<"Content-Type">>, Req),
    %{Path, _} = cowboy_http_req:path_info(Req),
    %URL = proplists:get_value(<<"url">>, PostVals),
    %io:format("req info is ~p ~n", [ContentType]),
    {Result, _} = acc_multipart(Req, []),
    {ok, File} = file:open("test_sharp_media_file", [raw, write]),
    file:write(File, Result),
    io:format("error data post ~n"),
    cowboy_http_req:reply(200, [{<<"Content-Encoding">>, <<"utf-8">>}], "OK", Req);

process('POST', false, Req) ->
    cowboy_http_req:reply(400, [], <<"Missing body.">>, Req);

process(_, _, Req) ->
    %% Method not allowed.
    cowboy_http_req:reply(405, Req).

terminate(Req, State) ->
    log4erl:info("~p~p~n", [Req, State]),
    ok.

acc_multipart(Req, Acc) ->
    {Result, Req2} = cowboy_http_req:multipart_data(Req),
    acc_multipart(Req2, Acc, Result).

acc_multipart(Req, Acc, {headers, Headers}) ->
    acc_multipart(Req, [{Headers, []}|Acc]);
acc_multipart(Req, [{Headers, BodyAcc}|Acc], {body, Data}) ->
    acc_multipart(Req, [{Headers, [Data|BodyAcc]}|Acc]);
acc_multipart(Req, [{Headers, BodyAcc}|Acc], end_of_part) ->
    acc_multipart(Req, [{Headers, list_to_binary(lists:reverse(BodyAcc))}|Acc]);
acc_multipart(Req, Acc, eof) ->
    {lists:reverse(Acc), Req}.


