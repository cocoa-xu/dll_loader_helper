-module(hello_test).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
    hello_nif:add(1, 2) == 3.
