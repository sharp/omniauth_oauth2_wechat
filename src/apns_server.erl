
-module(apns_connection).
-author('sharp').

-behaviour(gen_server).

-export([start_link/1, start_link/2, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([send_message/2, stop/1]).
-export([build_payload/1]).

-record(state, {out_socket        :: tuple(),
                in_socket         :: tuple(),
                connection        :: #apns_connection{},
                in_buffer = <<>>  :: binary(),
                out_buffer = <<>> :: binary()}).

start_link() ->
    gen_server:start_link(?MODULE, Connection, []).

send(Msg) ->
  gen_server:cast(ConnId, Msg).


%% @hidden
-spec init(#apns_connection{}) -> {ok, state()} | {stop, term()}.
init(Connection) ->
  try
    case open_out(Connection) of
      {ok, OutSocket} -> case open_feedback(Connection) of
          {ok, InSocket} -> {ok, #state{out_socket=OutSocket, in_socket=InSocket, connection=Connection}};
          {error, Reason} -> {stop, Reason}
        end;
      {error, Reason} -> {stop, Reason}
    end
  catch
    _:{error, Reason2} -> {stop, Reason2}
  end.

%% @hidden
-spec handle_call(X, reference(), state()) -> {stop, {unknown_request, X}, {unknown_request, X}, state()}.
handle_call(Request, _From, State) ->
  {stop, {unknown_request, Request}, {unknown_request, Request}, State}.