%% @author eavnvya
%% @doc @todo Add description to vec.


-module(vec).

%% ====================================================================
%% API functions
%% ====================================================================
-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).



%% ====================================================================
%% Internal functions
%% ====================================================================

zero()->
	0.

inc(Name, Time) ->
	case lists:keyfind(Name, 1, Time) of
		{N,T} ->
			lists:keyreplace(Name, 1, Time, {N, T+1});
		false ->
			[{Name, 1}|Time]
    end.

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
		{_,_} ->
			[{Node, Time}|lists:keydelete(Node, 1, Clock)];
		false ->
			[{Node, Time}|Clock]
	end.

safe(Time,Clock) ->
	MinTime = lists:foldl(fun({_,T}, MinTime) -> min(T,MinTime) end, inf, Clock),	
   if
	   (MinTime > Time)  ->
		   safe;
	   true -> 
		   not_safe
end.
