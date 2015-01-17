-module(server).
-record(state, {events, % list of events
    clients}). % list of clients

% an event description
-record(event, {name="", 
    description="", 
    pid, 
    timeout={{1970, 1, 1}, {0, 0, 0}}}).

init() ->
  loop(#state{events=orddict:new(), clients=orddict:new()}).

loop(S = #state{events=Events, clients=Clients}) ->
  receive ->
    {Pid, MsgRef, {subscribe, Client}} ->
      Ref = erlang:monitor(process, Client),
      NewClients = orddict:store(Ref, Client, S#state.clients),
      Pid ! {MsgRef, ok},
      loop(S#state{clients=NewClients});
    {Pid, MsgRef, {add, Name, Description, TimeOut}} ->
      EventId = event:start_link(Name, TimeOut),
      NewEvents = orddict:store(Name, #event{name=Name, description=Description, pid=EventId, timeout=TimeOut}, S#state.events),
      Pid ! {MsgRef, ok},
      loop(S#state{events=NewEvents});
    {Pid, MsgRef, {cancel, Name}} ->
      Events = case orddict:find(Name, S#state.events) of
        {ok, E} ->
          event:cancel(E#event.pid),
          orddict:erase(Name, S#state.events);
        error ->
          S#state.events
      end,
      Pid ! {MsgRef, ok},
      loop(S#state{events=Events});
    {done, Name} ->
      Events = case orddict:find(Name, S#state.events) of
        {ok, E} ->
          send_to_clients({done, E#event.name, E#event.description}, S#state.clients)
    shutdown
    {'DOWN', Ref, process, _Pid, _Reason}
    code_change
    Unknown ->
      io:format("Unknown message: ~p~n", [Unknown]),
      loop(State)
  end.
