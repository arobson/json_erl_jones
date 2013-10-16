#Why?
So Jiffy is good times. This depends on Jiffy. All it does is (attempt) to allow you to work with normal-sauce proplists without having to worry about Jiffy's very strict data format expectations. (see 'Comparisons' for comparisons).

If it's awful, feel free to tell me. Or just not use it. Or tell me about the alternative I was ignorant of. Or write something better so I can use your solution and burn this one down.

##API
It's very, very simple:

```erlang
json:encode([{a, test}]). %% outputs <<"{\"a\": \"test\"}">> a.k.a '{"a": "test"}'

json:decode(<<"{\"a\": \"test\"}">>). %% outputs [{a, <<"test">>}]
```

##Using it
You could just rip the json.erl file out and dump it into your source. It's cool. I won't tell anyone. Just be aware, I'm a novice Erlanger. This could be the dumbest. thing. ever.

### Rebar It
Add this to your rebar.config in the [{deps,[]}] collection

'''erlang
	{json_erl_jones, "",
		{git, "git://github.com/arobson/json_erl_jones",
		{branch, "master" } } }
'''

That's it. It should "just work"(tm) after that. Nothing to use.

##Dependencies
As I mentioned, it depends on Jiffy. Jiffy is cool. Paul Davis (@davisp), thanks for making a great JSON lib for Erlang.

#FAQ

### Q. Why not send a PR to Jiffy?
### A. I don't know the main dev and this drastically changes the input and output formats. It would break a lot of Jiffy's dependencies. Also, it may be "the worst idea ever".

### Q. Why are you so bad at computers?
### A. I'm trying to get better. Maybe send a PR so I can see how it could be better?

### Q. Why's your face so dumb?
### A. Now that's just mean.

#Comparisons
Normally you'd have to provide slightly different data for Jiffy to work. So from the previous examples, the data would have to be:

```erlang
%% this isn't so bad, right? why all the fuss ...
{[<<"a">>, <<"test">>]}. 

%% check out what happens
%% to a simple list of JSON objects
%% '[{"a": "test"}, {"b": "test"}]' becomes
{[{[{<<"a">>, <<"test">>}]},{[{<<"b">>, <<"test">>}]}]} %% WWWWWHHHYYYYYYYY!!!??

%% this lib lets you represent it as
[[{a, "test"}],[{b, "test"}]]

%% much, much better, yes?
```

I dunno about you, but when I look at the normal format, it makes my eyes bleed and my brain won't stop screaming. It's just awful to write any kind of code against. I dig proplists man. So I just want to use them and not worry about the formatting crap.