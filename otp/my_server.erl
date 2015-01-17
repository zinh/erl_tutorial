-module(my_server).

call(Pid, Msg) ->
  Ref = erlang:monitor(process, Pid),
  Pid ! {sync, self(), Ref, Msg},
  receive
    {Ref, Reply} ->
      erlang:demonitor(Ref, [flush]),
      Reply;
    {'DOWN', Ref, process, Pid, Reason} ->
      erlang:error(Reason)
  after 5000 ->
      erlang:error(timeout)
  end.

cast(Pid, Msg) ->
  Pid ! {async, Msg},
  ok.

loop(Module, State) ->
  receive
    {async, Msg} ->
      loop(Module, Module:handle_cast(Msg, State));
    {sync, Pid, Ref, Msg} ->
      loop(Module, Module:handle_call(Msg, {Pid, Ref}, State))
  end.

reply({Pid, Ref}, Reply) ->
  Pid ! {Ref, Reply}.

init(Module, InitState) ->
  loop(Module, Module:init(InitState)).

start_link(Module, InitState) ->
  spawn_link(fun() -> init(Module, InitState)).

start(Module, InitSate) ->
  spawn(fun() -> init(Module, InitState)).
