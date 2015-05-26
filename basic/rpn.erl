% revert polish notation calculator
-module(rpn).
-export([calc/1]).

% public api
calc(A) ->
  B = string:tokens(A, " "),
  [Result] = lists:foldl(fun calc/2, [], B),
  Result.

% private api
calc(H, Stack) ->
  case H of
    Ops when Ops == "+"; Ops == "-"; Ops == "*"; Ops == "/" ->
      {A, B, New_stack} = get_number(Stack),
      push(New_stack, binary_op(Ops, A, B));
    _ ->
      {A, _} = string:to_integer(H),
      push(Stack, A)
  end.

get_number(Stack) ->
  {A, B, S1} = pop2(Stack),
  {A, B, S1}.

% Stack
push(Stack, Item) ->
  [Item | Stack].

pop([H|T]) ->
  {H, T}.

pop2([H1 | [H2 | T]]) ->
  {H1, H2, T}.

binary_op(Ops, A, B) ->
  case Ops of
    "+" ->
      A + B;
    "-" ->
      A - B;
    "*" ->
      A * B;
    "/" ->
      A / B
  end.

t_func([A, B | T]) ->
  B.
