-module(couchbeam_test).
-export([start/0, run/0, stop/0, create_db/1, open_db/1, save/1, retrieve/1]).

start() ->
    crypto:start(),
    application:start(sasl),
    application:start(ibrowse), 
    application:start(couchbeam).

stop() ->
    crypto:stop(),
    application:stop(sasl),
    application:stop(ibrowse), 
    application:stop(couchbeam).

run() ->
    Host = "localhost",
    Port = 5984,
    Prefix = "",
    Options = [],
    Server = couchbeam:server_connection(Host, Port, Prefix, Options).

create_db(Server) ->
    Options = [],
    {ok, Db} = couchbeam:create_db(Server, "testdb", Options).

open_db(Server) ->    
    Options = [],
    {ok, Db} = couchbeam:open_db(Server, "testdb", Options).    

save(Db) ->
    Doc = {[
	    {<<"_id">>, <<"test">>},
	    {<<"content">>, <<"some text">>}
	   ]},
    {ok, Doc1} = couchbeam:save_doc(Db, Doc).      

retrieve(Db) ->
    {ok, Doc2} = couchbeam:open_doc(Db, "test").


    
  
  
  
  



