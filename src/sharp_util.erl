%%% @author sharp <sharp@sharp-Rev-1-0>
%%% @copyright (C) 2012, sharp
%%% @doc
%%%
%%% @end
%%% Created :  3 Aug 2012 by sharp <sharp@sharp-Rev-1-0>

-module(sharp_util).

%% API
-export([ 
	  bjoin/1,
	  create_filled_dict/2,
	  create_filled_queue/2,
	  get_env/1,
	  load_settings/1,
	  info/1,
	  is_valid_using_all_regexps/2,
	  is_valid_using_any_regexps/2,
	  merge_workers_lists/2,
	  remove_duplicates/1,
	  safe_binary_to_list/1,
	  safe_list_to_binary/1,
	  string_replacements_using_regexps/2
	 ]).

%%====================================================================
%% EBOT specific functions
%%====================================================================

bjoin(List) ->
    F = fun(A, B) -> <<A/binary," ",B/binary>> end,
    lists:foldr(F, <<>>, List).

create_filled_dict(Value, Keys) ->
    lists:foldl(
      fun(K, Acc) -> dict:store(K, Value, Acc) end,
      dict:new(),
      Keys
     ).

create_filled_queue(Value, QueueSize) ->
    lists:foldl(
      fun(_E, Q) -> queue:in(Value, Q) end,
      queue:new(),
      lists:seq(1, QueueSize)
     ).

get_env(Key) ->
    application:get_env(app_config, Key).
    
info(Config) ->
    Keys = proplists:get_keys(Config),
    KeysStrings =
	lists:map(
	  fun(X) -> atom_to_list(X) end,
	  Keys),
    Reply = "Options keys: " ++ string:join( KeysStrings, ", "),
    Reply.

merge_workers_lists(Dict1, Dict2) ->
    dict:merge(
      fun(_Key,Val1, Val2) -> lists:append(Val1, Val2) end,
      Dict1,
      Dict2).

is_valid_using_all_regexps(String, RElist) ->
    lists:all(
      fun({Result, RE}) ->
	      Result == re:run(String, RE, [{capture, none},caseless]) 
      end,
      RElist
     ).

is_valid_using_any_regexps(String, RElist) ->
    lists:any(
      fun({Result, RE}) ->
	      Result == re:run(String, RE, [{capture, none},caseless]) 
      end,
      RElist
     ).

load_settings(Module) ->
    %% TODO checking if file exists
    %% TODO compile all regexps inside the file
    File = filename:join([
			  filename:dirname(code:which(?MODULE)),
			  "..", "priv", atom_to_list(Module) ++ ".conf"]),
    error_logger:warning_report({?MODULE, ?LINE, {opening_configuration_file, File}}),
    file:consult(File).

remove_duplicates(L) ->
    lists:usort(L).

safe_binary_to_list(B) when is_binary(B) ->
    binary_to_list(B);
safe_binary_to_list(B) -> B.

safe_list_to_binary(L) when is_list(L) ->
    list_to_binary(L);
safe_list_to_binary(L) -> L.
    
string_replacements_using_regexps(String, RElist) ->
    lists:foldl(
      fun({From,To}, OldStr) ->
	      re:replace(OldStr, From, To,  [{return,list},global]) end,
      String,
      RElist
     ).

