-module(sc_element).
-behaviour(gen_server).
-export([start/2, start_link/2, fetch/1, replace/2, create/2, delete/1]).
-export([init/1, handle_info/2, handle_call/3, handle_cast/2, terminate/2, code_change/3]).
-record(state, {value, lease_time, last_read}).

start_link(Value, LeaseTime) ->
  {ok, Pid} = gen_server:start_link(?MODULE, [Value, LeaseTime], []),
  Pid.

create(Value, LeaseTime) ->
  sc_element_sup:start_child(Value, LeaseTime).

start(Value, LeaseTime) ->
  {ok, Pid} = gen_server:start(?MODULE, [Value, LeaseTime], []),
  Pid.

fetch(Pid) ->
  {ok, Value} = gen_server:call(Pid, fetch),
  Value.

delete(Pid) ->
  gen_server:cast(Pid, delete).

replace(Pid, Value) ->
  gen_server:cast(Pid, {replace, Value}).

init([Value, LeaseTime]) ->
  Now = calendar:local_time(),
  {ok, #state{value = Value, lease_time = LeaseTime, last_read = Now}, LeaseTime * 1000}.

handle_info(timeout, State) ->
  {stop, normal, State}.

handle_call(fetch, _From, State = #state{value = Value, lease_time = LeaseTime}) ->
  {reply, {ok, Value}, State#state{last_read = calendar:local_time()}, LeaseTime * 1000}.

handle_cast({replace, NewValue}, #state{lease_time = LeaseTime} = State) ->
  Now = calendar:local_time(),
  {noreply, State#state{value = NewValue, last_read = Now}, LeaseTime * 1000};

handle_cast(delete, State) ->
  {stop, normal, State}.

terminate(_Reason, State) ->
  sc_store:delete(self()),
  io:format("~p stopped~n", [State#state.value]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
