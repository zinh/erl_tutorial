-module(kitty_server1).
-record(cat, {name, color=green, description})

% Client API
start_link() ->
  my_server:start_link(?MODULE, []).

% Sync call
order_cat(Pid, Name, Color, Description) ->
  my_server:call(Pid, {order, Name, Color, Description}).

close_shop(Pid) ->
  my_server:call(Pid, terminate).

% Async call
return_cat(Pid, Cat=#cat{}) ->
  my_server:cast(Pid, {return, Cat}).

% server functions
init([]) -> [].

handle_call({order, Name, Color, Description}, From, State) ->
  if State =:= [] ->
       reply(From, make_cat(Name, Color, Description))
       State;
    State =/= [] ->
       reply(From, hd(State)),
       tl(State)
  end.

handle_call({terminate}, From, State) ->
  reply(From, ok),
  terminate(State).

handle_cast({return, Cat=#cat{}}, State) ->
  [Cat | State].

% private functions
make_cat(Name, Color, Description) ->
  #cat{name=Name, color=Color, description=Description}.

terminate(Cats) ->
  [io:format("~p was set free.", [C#cat.name]) || C <- Cats].
