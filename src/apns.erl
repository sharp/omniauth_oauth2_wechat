-module(apns).
-author('sharp').
-export([send/3]).

send(Connection, App, Msg) -> 
    io:format("message is ~p ~p ~p ~n", [Msg, Connection, App]).

