-module(kitty_server1).

% Synchronous call
order_cat(Pid, Name, Color, Description) ->
  my_server:call(Pid, {order, Name, Color, Description}).

close_shop(Pid) ->
  my_server:call(Pid, terminate).
