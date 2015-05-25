-module(sc_element).
-behaviour(gen_server).
-record(state, {value, lease_time, start_time}).
-define(DEFAULT_LEASE_TIME, (60*60*24)).

start_link([Value, LeaseTime]) ->
  gen_server:start_link(?MODULE, [Value, LeaseTime], []).

fetch(Pid) ->
  gen_server:call(Pid, fetch).

replace(Pid, Value) ->
  gen_server:cast(Pid, {replace, Value}).

init([Value, LeaseTime]) ->
  Now = calendar:local_time(),
  {ok,
    state#{value = Value, lease_time = LeaseTime, start_time = Now},
    time_left(LeaseTime, Now)}.

time_left(infinity, _StartTime) ->
  infinity;

time_left(LeaseTime, StartTime) ->
  Now = calendar:local_time(),
  CurrentTime = calendar:datetime_to_gregorian_seconds(Now),
  TimeElapsed = CurrentTime - StartTime,
  case LeaseTime - TimeElapsed of
    Time when Time =< 0 -> ;
    Time -> Time * 1000
  end.

handle_info(timeout, State) ->
  {stop, normal, State}.

handle_call(fetch, _From, State) ->
  State = #state{value = Value, lease_time = LeaseTime, start_time = StartTime},
  TimeLeft = time_left(LeaseTime, StartTime),
  {reply, {ok, Value}, State, TimeLeft}.

handle_cast({replace, NewValue}, #state{lease_time = LeaseTime}) ->
  Now = calendar:local_time(),
  TimeLeft = time_left(LeaseTime, Now),
  {noreply, #state{value = NewValue, lease_time = LeaseTime, start_time = Now}, TimeLeft}.
