% Alex Robson
% 9-10-13

-module(json_test).
-compile([export_all]).
-include_lib("eunit/include/eunit.hrl").

tuple_test() ->
	T1 = [{"a", "one"}],
	Out = json:prep(T1),
	?assertEqual({[{<<"a">>,<<"one">>}]}, Out).

list_of_tuple_test() ->
	T2 = [{"a","one"},{"b", 2}],
	Out = json:prep(T2),
	?assertEqual({[{<<"a">>,<<"one">>},{<<"b">>,2}]}, Out).

nested_tuples_test() ->
	T3 = [{"a", [{"b", 1}, {c, test}, {d, 10}]}],
	Out = json:prep(T3),
	?assertEqual({[{<<"a">>, {[{<<"b">>, 1}, {<<"c">>, <<"test">>}, {<<"d">>, 10}]}}]}, Out).

list_of_list_test() ->
	T4 = [[{"a", 1},{"b", 2}],[{"b", 2},{"c",3}],[{"a",1},{"c",3}]],
	Out = json:prep(T4),
	?assertEqual([
		{[{<<"a">>, 1},{<<"b">>, 2}]}, 
		{[{<<"b">>, 2},{<<"c">>, 3}]}, 
		{[{<<"a">>, 1},{<<"c">>, 3}]}
	], Out).

nested_list_of_list_test() ->
	T4 = [[{"a", [{"e", [{"f", 1}]}]}], [{"b", [{"h", [{"i", 2}]}]}],[{"c", [{"j",[{"k", 3}]}]}]],
	Out = json:prep(T4),
	?assertEqual([
		{[{<<"a">>, 
			{[{<<"e">>, 
				{[{<<"f">>, 1}]}}]}}]}, 
		{[{<<"b">>, 
			{[{<<"h">>, 
				{[{<<"i">>, 2}]}}]}}]},
		{[{<<"c">>, 
			{[{<<"j">>,
				{[{<<"k">>, 3}]}}]}}]}
		], Out).

simple_json_test() ->
	J1 = <<"{\"a\":\"test\"}">>,
	Out = json:decode(J1),
	?assertEqual([{a,<<"test">>}],Out).

json_object_list_test() ->
	J2 = <<"[{\"a\":\"test\"},{\"b\":10}]">>,
	Out = json:decode(J2),
	?assertEqual([[{a,<<"test">>}],[{b,10}]], Out).

json_nested_test() ->
	J3 = <<"{\"A\": [{\"b\": \"test\"}, {\"C\": \"test\"}]}">>,
	Out = json:decode(J3),
	?assertEqual([{a, [[{b, <<"test">>}],[{c, <<"test">>}]]}], Out).