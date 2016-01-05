#! /usr/bin/env escript
%%! -smp enable -mnesia debug verbose -Wall -pz ../deps/bson/ebin ../ebin

-module(m_test).

-export([start/0]).

start() ->
    ok=application:start(mongodb),
    {ok,Pid}=mongoc:start_link(),
    ReplSet={<<"rs0">>, [{localhost, 27018}, {localhost, 27019},{localhost,27020}]},
    {ok,RelCon}=mongoc:rs_connect(Pid,ReplSet,[]),
    %Sec=mongo_replset:secondary_ok(RelCon),
    {ok,Prim}=mongo_replset:primary(RelCon),
    %io:format("first get~p~n",[erlang:get(mongo_action_context)]),
    %%{ok,A}=mongo:do(unsafe,master,RelCon,mongo,fun() -> ok end),
    %mongo:save_config(unsafe,master,RelCon,mongo),
    Sec=0,
    %io:format("atfer do get~p~n",[erlang:get(mongo_action_context)]),
    io:format("Rs:~p~nPrimary:~p~nSecondary:~p~n",[RelCon,Prim,Sec]),
    %Res0=mongo:insert ({mongodb,Prim},foo, {x,1, y,2}),
    %io:format("insert: Res~p~n",[Res0]),
    Res=mongo:find_one ({test,Prim},foo, {x,1}),
    io:format("find: Cursor~p~n",[Res]),
    mongo:rs_disconnect(RelCon).

main(_Args) ->
    start().
