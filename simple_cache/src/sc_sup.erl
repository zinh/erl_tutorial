-module(sc_sup).
-behaviour(supervisor).
-export([init/1, start_link/0]).
-define(SERVER, ?MODULE).

start_link() ->
	supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
	ElementSup = {sc_element_sup, 
			   {sc_element_sup, start_link, []},
			   transient, infinity, supervisor, [sc_element_sup]},
	EventManager = {sc_event, 
			 {sc_event, start_link, []}, 
			 transient, brutal_kill, worker, [sc_event]},
	RestartStrategy = {one_for_one, 4, 3600},
	ChildSpec = [ElementSup, EventManager],
	{ok, {RestartStrategy, ChildSpec}}.