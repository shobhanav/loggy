%% @author eavnvya
%% @doc @todo Add description to logger.


-module(logger).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1, stop/1]).

start(Nodes) ->
	spawn_link(fun() ->init(Nodes) end).

stop(Logger) ->
	Logger ! stop.

init(Nodes) ->
	MsgQ = [],
	Clock = time:clock(Nodes),
	loop(MsgQ, Clock).


%% ====================================================================
%% Internal functions
%% ====================================================================

loop(MsgQ, Clock) ->
	receive
		{log, From, Time, Msg} ->
			NewClock = time:update(From, Time, Clock),
			Q = lists:keysort(2, [{From,Time,Msg}|MsgQ]),			
			NewMsgQ = lists:dropwhile(fun({F,T,M})->
									case time:safe(T, NewClock) of
										safe ->
											log(F,T, M),
											true;
										not_safe ->
											false
										end 
									  end,									
									 Q),
			loop(NewMsgQ, NewClock);
		stop ->
			ok
	end.

log(From, Time, Msg) ->
	io:format("log: ~w ~w ~p~n", [Time, From, Msg]).


		
	
	