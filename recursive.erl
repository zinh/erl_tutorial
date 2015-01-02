-module(recursive).
-export([fac/1, tail_fac/1, duplicate/2, reverse/1, reverse_tail/1, sublist/2]).

fac(0) ->
  1;
fac(N) when N > 0 ->
  N * fac(N - 1).

tail_fac(N) ->
  tail_fac(1, N).

tail_fac(X, 1) ->
  X;
tail_fac(X, N) when N > 1 ->
  tail_fac(X*N, N - 1).

duplicate(N, Term) ->
  duplicate(N, Term, []).

duplicate(0, _, List) ->
  List;
duplicate(N, Term, List) when N > 0 ->
  duplicate(N - 1, Term, [Term | List]).

reverse([]) ->
  [];
reverse([N | List]) ->
  reverse(List) ++ [N].

reverse_tail(L) ->
  reverse_tail(L, []).

reverse_tail([], List) ->
  List;
reverse_tail([H | T], List) ->
  reverse_tail(T, [H] ++ List).

sublist(N, List) ->
  sublist(N, List, []).

sublist(_, [], Acc) ->
  Acc;
sublist(0, _, Acc) ->
  Acc;
sublist(N, [H | T], Acc) when N > 0 ->
  sublist(N - 1, T, Acc ++ [H]).
