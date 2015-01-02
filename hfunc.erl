% high order functions
-module(hfunc).
-compile(export_all).

% hfunc:hmap([1,2,3,4], fun(A) -> A * A end).
% -> [1,4,9,16]
hmap(List, F) ->
  hmap(List, F, []).

hmap([], _, Acc) ->
  Acc;
hmap([H|T], F, Acc) ->
  hmap(T, F, Acc ++ [F(H)] ).

% hfunc:hfilter([1,2,3,4], fun(A) -> A rem 2 == 0 end).
hfilter(List, F) ->
  hfilter(List, F, []).

hfilter([], _, Acc) ->
  Acc;
hfilter([H|T], F, Acc) ->
  case F(H) of
    true -> hfilter(T, F, Acc);
    false -> hfilter(T, F, Acc ++ [H])
  end.

% hfunc:hreduce([1,2,3,4], fun(A, B) -> A + B end, 1).
hreduce([], _, Acc) ->
  Acc;
hreduce([H|T], F, Acc) ->
  hreduce(T, F, F(H, Acc)).
