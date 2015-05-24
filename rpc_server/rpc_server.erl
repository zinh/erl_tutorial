-module(rpc_server).
-behaviour(gen_server).
-export([]).
-record(state, {count = 0, socket, port}).

%% Public API
start_link() ->
  gen_server:start_link({local, rpc_server}, rpc_server, 4000, []).
%% gen_server callback
init(Port) ->
  {ok, LSock} = gen_tcp:listen(Port, [{active, true}]),
  {ok, #state{port=Port, socket=LSock}, 0}.

handle_info({tcp, Socket, RawData}, State) ->
  do_rpc(Socket, RawData),
  RequestCount = State#state.count + 1,
  {noreply, State#state{count = RequestCount}};

handle_info(timeout, #state{sock = LSock} = State) ->
  {ok, _Sock} = gen_tcp:accept(LSock),
  {noreply, State}.

%% private function
do_rpc(Socket, RawData) ->
  try
    {M, F, A} = split_out_mfa(RawData),
    Result = apply(M, F, A),
    gen_tcp:send(Socket, io_lib:fwrite("~p~n", [Result]))
  catch
    _Class:Err ->
      gen_tcp:send(Socket, io_lib:fwrite("~p~n", [Err]))
  end

split_out_mfa(RawData) ->
  MFA = re:replace(),
  {match, [M, F, A]} = re:run(MFA, "(.*):(.*)\s*\\((.*)\s*\\)\s*.\s*$"),
  {list_to_atom(M), list_to_atom(F), args_to_terms(A)}.

args_to_terms(RawArgs) ->
  {ok, Toks, _Line} = erl_scan:string("[" ++ RawArgs ++ "]. ", 1),
  {ok, Args} = erl_parse:parse_term(Toks),
  Args.
