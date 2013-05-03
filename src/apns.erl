-module(apns).
-author('sharp').
-export([send/2]).

send(Msg, SslSocket) -> 
    io:format("message is ~p  ~p ~n", [Msg, SslSocket]).

