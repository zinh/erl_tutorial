-module(sc_store).
-export([init/0, insert/2, lookup/1, delete/1]).
-record(process, {key, pid}).

init() ->
  mnesia:start(),
  mnesia:create_table(process, [{index, [pid]}, {attributes, record_info(fields, process)}]),
  ok.

insert(Key, Pid) ->
  Fun = fun() ->
      mnesia:write(#process{key = Key, pid = Pid})
  end,
  mnesia:transaction(Fun).

lookup(Key) ->
  case mnesia:dirty_read(process, Key) of
    [] -> {error, not_found};
    [{process, Key, Pid}] ->
      case is_pid_alive(Pid) of
        true -> {ok, Pid};
        false -> {error, not_found}
      end
  end.

delete(Pid) ->
  case mnesia:dirty_index_read(process, Pid, #process.pid) of
    [#process{} = Record] ->
      mnesia:dirty_delete_object(Record);
    _ ->
      ok
  end.

is_pid_alive(Pid) when node(Pid) =:= node() ->
  is_process_alive(Pid);

is_pid_alive(Pid) ->
  lists:member(node(Pid), nodes()) andalso
  (rpc:call(node(Pid), erlang, is_process_alive, [Pid]) =:= true).
