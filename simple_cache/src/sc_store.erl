-module(sc_store).
-export([init/0, insert/2, lookup/1, delete/1]).

-define(TABLE_ID, ?MODULE).

init() ->
  ets:new(?TABLE_ID, [public, named_table]),
  ok.

insert(Key, Pid) ->
  ets:insert(?TABLE_ID, {Key, Pid}),
  ok.

lookup(Key) ->
  case ets:lookup(?TABLE_ID, Key) of
    [] -> {error, not_found};
    [{Key, Pid} | _] -> {ok, Pid}
  end.

delete(Pid) ->
  ets:match_delete(?TABLE_ID, {'_', Pid}),
  ok.
