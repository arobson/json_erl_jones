%%% @author Alex Robson
%%% @copyright 2013
%%% @doc
%%%
%%% Working with JSON in Erlang hurts. Jiffy makes that a bit easier.
%%% This only exists to make it simpler to use Jiffy.
%%%
%%% @end
%%% Licensed under the MIT license - http://www.opensource.org/licenses/mit-license
%%% Created October 11, 2013 by Alex Robson

-module(json).

-export([ 
			encode/1,
			encode/2,
			decode/1
		]).


%% Hi, haters. 
%% That's right. I put this in here. I prefer this to cramming
%% tons of test code into my relatively clean module.
%% I've heard the arguments against, but tests IN the module =:= gross.
-ifdef(TEST). 
-compile([export_all]).
-endif.

decode(Json) ->
	strip(jiffy:decode(Json)).

encode(PropList) ->
	jiffy:encode(prep(PropList)).

encode(PropList, Options) ->
	jiffy:encode(prep(PropList), Options).

prep(X) when is_tuple(X) -> prep_tuple(X);
prep(X) when is_list(X) -> prep_list(X);
prep(X) when is_atom(X) -> prep_atom(X);
prep(X) -> X.

prep_atom(X) -> atom_to_binary(X, utf8).

prep_list([]) -> [];
prep_list([[{_,_}|_]=H|T]) -> [prep(H)|prep(T)];
prep_list([{_,_}=H|T]) ->
	case T of
		[] -> {[prep(H)]};
		_ ->
			{TL} = prep(T),
			{[prep(H)] ++ TL}
	end;
prep_list([H|T]=L) ->
	case io_lib:printable_list(L) orelse io_lib:printable_unicode_list(L) of
		true ->
			list_to_bitstring(L);
		_ ->
			case T of
				[] -> [prep(H)];
				_ -> [prep(H)|prep(T)]
			end
	end.

prep_tuple({X,Y}) -> {prep(X), prep(Y)}.

strip([]) -> [];
strip(X) when is_list(X) -> strip_list(X);
strip(X) when is_tuple(X) -> strip_tuple(X);
strip(X) -> X.

strip_list([H|T]) -> 
	case T of
		[] -> [strip(H)];
		_ -> [strip(H)] ++ strip(T)
	end.

strip_tuple({X,Y}) ->
	NewX = to_atom(X),
	{NewX, strip(Y)};
strip_tuple({X}) when is_list(X) -> strip(X).

to_atom(X) -> list_to_atom(bitstring_to_list(X)).