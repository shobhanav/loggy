%% @author eavnvya
%% @doc @todo Add description to time.


-module(time).

%% ====================================================================
%% API functions
%% ====================================================================
-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).

zero()->
	0.

inc(Name, T) ->
	T+1.

merge(Ti,Tj) ->
	erlang:max(Ti, Tj).


leq(Ti, Tj) ->
	if
		Ti< Tj -> 
			true;
		Ti == Tj ->
			true;
		true ->
			false
	end.
		
clock(Nodes) ->
	lists:map(fun(X)->{X,0} end , Nodes).

update(Node, Time, Clock) ->
	case lists:keyfind(Node, 1, Clock) of
		{N,T} ->
			if 
				(Time > T) ->
					[{Node, Time}|lists:keydelete(Node, 1, Clock)];
				true ->
					Clock
			end;
		false ->
			[{Node, Time}|Clock]
	end.

safe(Time,Clock) ->
	MinTime = lists:foldl(fun({_,T}, MinTime) -> min(T,MinTime) end, inf, Clock),	
   if
	   (MinTime >= Time)  ->
		   safe;
	   true -> 
		   not_safe
end.
		

%% ====================================================================
%% Internal functions
%% ====================================================================


