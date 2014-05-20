%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(hello_world_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

-define(TRANS_OPTS, [{ip, {127,0,0,1}}, {port, 8000}]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", toppage_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, ?TRANS_OPTS, [
		{env, [{dispatch, Dispatch}]}
	]),
	hello_world_sup:start_link().

stop(_State) ->
	ok.
