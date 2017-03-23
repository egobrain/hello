-module(hello_handler).

-export([
    init/3,
    content_types_provided/2,
    hello_json/2
]).

init(_Transport, _Req, []) ->
    {upgrade, protocol, cowboy_rest}.

content_types_provided(Req, State) ->
    {[
        {<<"application/json">>, hello_json}
    ], Req, State}.

hello_json(Req, State) ->
    {Name, Req2} = cowboy_req:qs_val(<<"name">>, Req, <<"World">>),
    Msg = #{rest => <<"Hello, ", Name/binary, "!">>},
    Json = jiffy:encode(Msg),
    {Json, Req2, State}.
