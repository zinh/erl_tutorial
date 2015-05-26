% multi process
-module(dolphins).
-compile(export_all).

dolphin1() ->
  receive
    do_a_flip ->
      io:format("How about no?~n");
    fish ->
      io:format("I want more fish~n");
    _ ->
      io:format("I am dumb here?!!~n")
  end.

dolphin2() ->
  receive
    {From, do_a_flip} ->
      From ! "Flip flip flip~n";
    {From, fish} ->
      From ! "I want more fish~n";
    {From, _} ->
      From ! "Now I am dumb~n"
  end.

dolphin3() ->
  receive
    {From, do_a_flip} ->
      From ! "Flip flip flip~n",
      dolphin3();
    {From, fish} ->
      From ! "I want more fish~n";
    {From, _} ->
      From ! "Now I am dumb~n",
      dolphin3()
  end.
