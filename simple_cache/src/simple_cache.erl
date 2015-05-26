-module(simple_cache).
-export([insert/2, lookup/1, delete/1]).

insert(Key, Value) ->
  case sc_store:lookup(Key) of
    {error, _} ->
      {_, Pid} = sc_element:create(Value, 20),
      sc_store:insert(Key, Pid);
    {ok, Pid} -> sc_element:replace(Pid, Value)
  end.

lookup(Key) ->
  case sc_store:lookup(Key) of
    {error, _} -> {error, not_found};
    {ok, Pid} -> sc_element:fetch(Pid)
  end.

delete(Key) ->
  case sc_store:lookup(Key) of
    {error, _} -> {error, not_found};
    {ok, Pid} -> sc_element:delete(Pid)
  end.
