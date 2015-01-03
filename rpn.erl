% revert polish notation calculator
-module(rpn).
-compile(export_all).

calc(A) ->
  B = string:tokens(A, " "),
  lists:foldl(fun calc/2, [], B).

calc(H, Stack) ->
  case H of
    "+" ->
      {A, B, New_stack} = get_number(Stack),
      push(New_stack, A + B);
    "-" ->
      {A, B, New_stack} = get_number(Stack),
      push(New_stack, A - B);
    _ ->
      {A, _} = string:to_integer(H),
      push(Stack, A)
  end.

get_number(Stack) ->
  {A, B, S1} = pop2(Stack),
  {A, B, S1}.

push(Stack, Item) ->
  [Item | Stack].

pop([H|T]) ->
  {H, T}.

pop2([H1 | [H2 | T]]) ->
  {H1, H2, T}.
