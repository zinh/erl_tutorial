-module(event_handler).
-behaviour(gen_event).
-export([init/1, handle_event/2, terminate/2]).

init(_Args) ->
  {ok, []}.

handle_event({lookup, Key}, State) ->
  io:format("[INFO] Looking for: ~p~n", [Key]),
  {ok, State};

handle_event({create, {Key, Value}}, State) ->
  io:format("[INFO] New item add: (~p, ~p)~n", [Key, Value]),
  {ok, State}.

terminate(_Msg, _State) ->
  ok.
