% revert polish notation calculator
-module(rpn).
-compile(export_all).

calc(A) ->
  B = string:tokens(A, " "),
  calc(B, []).

calc([], Stack) ->
  Stack;
calc([H|T], Stack) ->
  case H of
    "+" ->
      {A, B, New_stack} = get_number(Stack),
      Current_stack = push(New_stack, A + B),
      calc(T, Current_stack);
    "-" ->
      {A, B, New_stack} = get_number(Stack),
      Current_stack = push(New_stack, A - B),
      calc(T, Current_stack);
    _ ->
      {A, _} = string:to_integer(H),
      New_stack = push(Stack, A),
      calc(T, New_stack)
  end.

get_number(Stack) ->
  {A, B, S1} = pop2(Stack),
  {A, B, S1}.

push(Stack, Item) ->
  Stack ++ [Item].

pop([H|T]) ->
  {H, T}.

pop2([H1 | [H2 | T]]) ->
  {H1, H2, T}.
