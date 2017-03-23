%%%-------------------------------------------------------------------
%% @doc hello public API
%% @end
%%%-------------------------------------------------------------------

-module(hello_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    {ok, Port} = application:get_env(hello, http_port),
    {ok, AcceptorsNum} = application:get_env(hello, http_acceptors_num),
    TcpOpts = application:get_env(hello, tcp_opts, []),

    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api/v1.0/hello", hello_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, AcceptorsNum, [{port, Port}|TcpOpts], [
        {env, [{dispatch, Dispatch}]}
    ]),
    hello_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    cowboy:stop_listener(http),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
