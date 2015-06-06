-module(sc_store_mnesia).
-record(process, {key, pid}).

init() ->
  mnesia:start(),
  mnesia:create_table(process, [{attributes, record_info(fields, process)}]),
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

is_pid_alive(Pid) when node(Pid) =:= node() ->
  is_process_alive(Pid);

is_pid_alive(Pid) ->
  lists:member(node(Pid), nodes()) andalso
  (rpc:call(node(Pid), erlang, is_process_alive, [Pid]) =:= true).
