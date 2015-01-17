-module(stack).
-export([start/0, push/2, pop/1]).

% Start a blank stack process
start() ->
  spawn(?MODULE, stack, [[]]).

% Main stack process
stack(List) ->
  receive
    {From, push, Item} ->
      From ! "pushed",
      stack([Item | List]);
    {From, pop} ->
      [H | T] = List,
      From ! H,
      stack(T);
    {From, _} ->
      From ! "Unsupported operation!"
  end.

% Helper function
push(Pid, Item) ->
  Pid ! {self(), push, Item}.

% Helper function
pop(Pid) ->
  Pid ! {self(), pop}.
