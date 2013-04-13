flight(ba58, singapore, london, 2310, 520, mon).
flight(ba58, singapore, london, 2310, 520, wed).
flight(ba58, singapore, london, 2310, 520, thu).
flight(ba58, singapore, london, 2310, 520, sat).

flight(ba24, london, singapore, 1000, 1600, mon).
flight(ba24, london, singapore, 1000, 1600, wed).
flight(ba24, london, singapore, 1000, 1600, thu).
flight(ba24, london, singapore, 1000, 1600, sat).

flight(ba4732, london, edinburgh, 0940, 1050, mon).
flight(ba4732, london, edinburgh, 0940, 1050, tue).
flight(ba4732, london, edinburgh, 0940, 1050, wed).
flight(ba4732, london, edinburgh, 0940, 1050, thu).
flight(ba4732, london, edinburgh, 0940, 1050, fri).
flight(ba4732, london, edinburgh, 0940, 1050, sat).
flight(ba4732, london, edinburgh, 0940, 1050, sun).

flight(ba4735, london, edinburgh, 1140, 1250, mon).
flight(ba4735, london, edinburgh, 1140, 1250, tue).
flight(ba4735, london, edinburgh, 1140, 1250, wed).
flight(ba4735, london, edinburgh, 1140, 1250, thu).
flight(ba4735, london, edinburgh, 1140, 1250, fri).
flight(ba4735, london, edinburgh, 1140, 1250, sat).
flight(ba4735, london, edinburgh, 1140, 1250, sun).

flight(ba4822, london, edinburgh, 1840, 1950, mon).
flight(ba4822, london, edinburgh, 1840, 1950, tue).
flight(ba4822, london, edinburgh, 1840, 1950, wed).
flight(ba4822, london, edinburgh, 1840, 1950, thu).
flight(ba4822, london, edinburgh, 1840, 1950, fri).

flight(ba4733, edinburgh, london, 0830, 0940, mon).
flight(ba4733, edinburgh, london, 0830, 0940, tue).
flight(ba4733, edinburgh, london, 0830, 0940, wed).
flight(ba4733, edinburgh, london, 0830, 0940, thu).
flight(ba4733, edinburgh, london, 0830, 0940, fri).
flight(ba4733, edinburgh, london, 0830, 0940, sat).
flight(ba4733, edinburgh, london, 0830, 0940, sun).

day(mon, 1).
day(tue, 2).
day(wed, 3).
day(thu, 4).
day(fri, 5).
day(sat, 6).
day(sun, 7).

append(H, L, [H,L]).

absolute_time(Time_of_day, Day, Abs_Time):- day(Day,X),
	Abs_Time is (((Time_of_day//100)*60)+(mod(Time_of_day,100)) + (X-1)*1440).

time_difference(Start_time, Start_Day, End_time, End_day, Time_Diff):- 
	absolute_time(Start_time, Start_Day, Start_Abs), 
	absolute_time(End_time, End_day, End_Abs), 
	Diff is (End_Abs - Start_Abs), 
	Time_Diff is (mod(Diff, 10080)).

time_difference_in_week(Start_time, Start_Day, End_time, End_day, Time_Diff):- 
	absolute_time(Start_time, Start_Day, Start_Abs), 
	absolute_time(End_time, End_day, End_Abs), 
	Time_Diff is (End_Abs - Start_Abs).

adjusted_schedule(Start_time, End_time, Start_Day, End_day) :-
	flight(First_Flight,X,Y,Start_time,End_time,Start_Day),
	absolute_time(Start_time, Start_Day, Start_Abs), 
	absolute_time(End_time, End_day, End_Abs), 
	End_Abs < Start_Abs, day(Start_Day, Old_Day), New_Day_int is (Old_Day+1), day(New_Day, New_Day_int), End_day is New_Day;
	End_day is Start_Day.

one_change_travel_time(First_Flight, FF_Day, Second_Flight, SF_Day, Travel_Time):- 
	flight(First_Flight,X,Y,FF_Start,FF_End,FF_Day),
	flight(Second_Flight,W,Z,SF_Start,SF_End,SF_Day),
	time_difference(FF_Start, FF_Day, FF_End, FF_Day, FF_Duration),
	time_difference(SF_Start, SF_Day, SF_End, SF_Day, SF_Duration),
	time_difference(FF_End, FF_Day, SF_Start, SF_Day, Transit_Time),
	Travel_Time is (FF_Duration + SF_Duration + Transit_Time).

member_of(X,[X|_]):- !.
member_of(X,[_|T]) :- member_of(X,T).

remove_duplicate([],[]).
remove_duplicate([H|T],[H|Out]) :-
   not(member_of(H,T)),
   !,
remove_duplicate(T,Out).
remove_duplicate([H|T],Out) :-
   member_of(H,T),
   remove_duplicate(T,Out).

find_direct_flights(Origin, Destination, List):-
	findall([X0, X1], flight(X0, Origin, Destination, Q, W, X1), X),
	remove_duplicate(X, List).

find_all_direct_flights_after(Origin, Destination, Time, Day, Number):-
	flight(Number, Origin, Destination, Start_time, End_time, Flight_Day).

find_distinct_direct_flights_after(Origin, Destination, Time, Day, List):-
	findall(X0, find_all_direct_flights_after(Origin, Destination, Time, Day, X0), X),
	remove_duplicate(X, List).
	
find_all_flight_and_travel_time(Number, Origin, Destination, Time, Day, Travel_Time):-
	flight(Number, Origin, Destination, Start_time, End_time, Flight_Day),
	time_difference(Time, Day, Start_time, Flight_Day, Travel_Time).

list_flights_and_travel_times(Origin, Destination, Time, Day, List):-
	findall([Number, Travel_Time], find_all_flight_and_travel_time(Number, Origin, Destination, Time, Day, Travel_Time), X).

find_direct_flight(Origin, Destination, Day):-
	flight(Number, Origin, Destination, _, _, Day),
	write(Origin), write(' to '), write(Destination), write('\n').



find_flights(Origin, Destination, Number):-
	find_direct_flight(Origin, Destination, mon);
	flight(W, Origin, Buffer, X, Y, Z),
	find_flights(Buffer, Destination, Number).



%% CASE 1: Next node is the destination
route(Origin, Destination, DeptTime, ArrTime, Day, [[Flightno, New_Day]], Visited):-
    flight(Flightno, Origin, Destination, Dept1, Arr1, New_Day),
    not(member(Destination,Visited)).
        

%% CASE 2: 
route(Origin, Destination, Dept_Time, Arr_Time, Day, [[Flightno, New_Day]|Route], Visited):-
    flight(Flightno, Origin, Transit, DeptTime, ArrTime, New_Day),
    not(member(Transit,Visited)),
    route(Transit, Destination, Dept1, Arr1, Day, Route, [Transit|Visited]).
	

%% Query Part
plan_route(Origin_City, Destination_City, Day, Route):- 
    route(Origin_City, Destination_City, Dept_Time, Arr_Time, Day, Route, [Origin_City]).


process_flight_node([Number, Day|Empty], Start_time, End_time, Day):-
	flight(Number, Origin, Destination, Start_time, End_time, Day).

calculate_route_time([First_Flight|Route], Time):-	
	process_route([First_Flight|Route], 0, Time).

calculate_route_time_from_specified_time([First_Flight|Route], Start_time, Start_Day, Time):-	
	process_flight_node(First_Flight, FF_Start, FF_End, FF_Day),
	time_difference(Start_time, Start_Day, FF_Start, FF_Day, InitialWait),
	process_route([First_Flight|Route], 0, Route_time),
	Time is (Route_time + InitialWait).

last_element_of_list([Last|[]], Last).  

last_element_of_list([Y|Tail], Last):-
    last_element_of_list(Tail, Last).

find_route_options_and_time(Origin, Destination, Day, Route, Travel_Time, Total_time):-
	plan_route(Origin, Destination, Day, Route),
	calculate_route_time(Route, Travel_Time),
	calculate_route_time_from_specified_time(Route, 0000, Day, Total_time).

list_route_options_and_travel_time(Origin, Destination, Day, Route, List):-
	findall([Route,Time],find_route_options_and_time(Origin, Destination, Day, Route, Time, _),List).

list_route_options_and_total_time(Origin, Destination, Day, Route, List):-
	findall([Route,Time],find_route_options_and_time(Origin, Destination, Day, Route, _, Time),List).


extract_times([[Route, Time|Nothing]|[]], List, [Time|List]).

extract_times([[Route, Time|Nothig]|Tail], List, Result):-
	extract_times(Tail, [Time|List], Result).

length_of([],0).
length_of([H|T],N) :- length_of(T,M), N is M+1.

extract_all_times(Origin, Destination, Day, Route, List):-
	list_route_options_and_total_time(Origin, Destination, Day, Route, RouteList),
	extract_times(RouteList,[], List).

process_route([First_Flight, Second_Flight|Route], Time, Result):-
	process_flight_node(First_Flight, FF_Start, FF_End, FF_Day),
	process_flight_node(Second_Flight, SF_Start, SF_End, SF_Day),
	time_difference(FF_Start, FF_Day, FF_End, FF_Day, FF_Duration),
	time_difference(FF_End, FF_Day, SF_Start, SF_Day, Transit_Time),
	New_time is (Time + FF_Duration + Transit_Time),
	process_route([Second_Flight|Route], New_time, Result).

process_route([First_Flight, Second_Flight|[]], Time, Result):-
	process_flight_node(First_Flight, FF_Start, FF_End, FF_Day),
	process_flight_node(Second_Flight, SF_Start, SF_End, SF_Day),
	time_difference(FF_Start, FF_Day, FF_End, FF_Day, FF_Duration),
	time_difference(SF_Start, SF_Day, SF_End, SF_Day, SF_Duration),
	time_difference(FF_End, FF_Day, SF_Start, SF_Day, Transit_Time),
	New_time is (Time + FF_Duration + Transit_Time + SF_Duration),
	process_route([], New_time, Result).

process_route([First_Flight|[]], Time, Result):-
	process_flight_node(First_Flight, FF_Start, FF_End, FF_Day),
	time_difference(FF_Start, FF_Day, FF_End, FF_Day, FF_Duration),
	Result is (Time + FF_Duration).
	
min_in_list([Min],Min).

min_in_list([H,K|T],M) :-
    H =< K,
    min_in_list([H|T],M).

min_in_list([H,K|T],M) :-
    H > K,
    min_in_list([K|T],M).

copy(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).

find_fastest_route(Origin, Destination, Day):-
	list_route_options_and_total_time(Origin, Destination, Day, X, RouteList),
	extract_times(RouteList, [], TimeList),
	min_in_list(TimeList, MinTime),
	extract_fastest_route_from_list(RouteList, MinTime).

extract_fastest_route_from_list([[Route, Time|Nothing]|Tail], MinTime):-
	Time = MinTime, 
	print_route(Route),
	extract_fastest_route_from_list(Tail, MinTime); 
	extract_fastest_route_from_list(Tail, MinTime).

extract_fastest_route_from_list([], MinTime):-false.
	

print_route([[Number, Day|Empty], Second_Flight|Route]):-
	flight(Number, Origin, Destination, Start_time, End_time, Day),
	write('     Flight Number: '), 
	write(Number), 
	write(' ('),
	write(Origin), 
	write(' to '),
	write(Destination), 
	write(')\n'), 
	write('		Departure:'), 
	print_time(Start_time),
	write(' on '),
	write(Day), 
	write('\n'),
	write('		Arrival  :'),
	print_time(End_time),
	write('.\n'),
	time_difference(Start_time, Day, End_time, Day, Duration),
	write('		Duration :'),
	print_time_difference(Duration),
	write('\n'),
	process_flight_node(Second_Flight, SF_Start, SF_End, SF_Day),
	time_difference(End_time, Day, SF_Start, SF_Day, Transit_Time),
	write('\n'),
	write('     Wating Time: '),
	print_time_difference(Transit_Time),
	write('\n\n'),

	print_route([Second_Flight|Route]).



print_route([[Number, Day|Empty]|[]]):-
	flight(Number, Origin, Destination, Start_time, End_time, Day),
	write('     Flight Number: '), 
	write(Number), 
	write(' ('),
	write(Origin), 
	write(' to '),
	write(Destination), 
	write(')\n'), 
	write('		Departure:'), 
	print_time(Start_time),
	write(' on '),
	write(Day), 
	write('\n'),
	write('		Arrival  :'),
	print_time(End_time),
	write('.\n'),
	time_difference(Start_time, Day, End_time, Day, Duration),
	write('		Duration :'),
	print_time_difference(Duration),
	write('\n'),
	write('\n'),
	print_route([]).	


print_route([]).

print_time(Time):- Time<1000, write('0'), write(Time), write('HRS').
print_time(Time):- Time>=1000,write(Time), write('HRS').
print_time_difference(Minutes):-
	Hours is Minutes//60,
	print_hours(Hours),
	Mins is mod(Minutes,60),
	print_minutes(Mins).

print_hours(Hours):- Hours>=1, write(Hours), write(' hours ').
print_hours(Hours):- Hours<1, write('').


print_minutes(Minutes):- Minutes>=1, write(Minutes), write(' minutes').
print_minutes(Minutes):- Minutes<1, write('').




















