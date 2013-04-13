%%Paths between cities
%% path(FlightNo., Origin, Destination, DeptTime, ArrTime, [DayList]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path(ba58, singapore, london, 23:10, 5:20, [mon, wed, thu, sat]).

path(ba24, london, singapore , 10:00, 16:00, [mon, wed, thu, sat]).

path(ba4732, london,  edinburgh , 09:40, 10:50, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4735, london,  edinburgh , 11:40, 12:50, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4822, london,  edinburgh , 18:40, 19:50, [mon, tue, wed, thu, fri]).

path(ba4733,  edinburgh, london, 08:30, 09:40, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4736,  edinburgh, london, 13:40, 14:50, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4833,  edinburgh, london, 19:40, 20:50, [mon, tue, wed, thu, fri, sun]).

path(ba614, london, greece, 09:10, 12:45, [mon, tue, wed, thu, fri, sat, sun]).
path(sr805, london, greece, 14:45, 18:20, [mon, tue, wed, thu, fri, sat, sun]).

path(ba613, greece, london, 09:00, 11:40, [mon, tue, wed, thu, fri, sat]).
path(sr806, greece, london, 16:10, 18:55, [mon, tue, wed, thu, fri, sun]).

path(ba510, london, paris, 08:30, 10:30, [mon, tue, wed, thu, fri, sat, sun]).
path(az459, london, paris, 13:10, 15:10, [mon, tue, wed, thu, fri, sat, sun]).

path(ba511, paris, london, 09:10, 10:20, [mon, tue, wed, thu, fri, sat, sun]).
path(az460, paris, london, 12:20, 13:30, [mon, tue, wed, thu, fri, sat, sun]).

path(jp322, paris, rome, 11:30, 12:40, [tue, wed, thu]).

path(jp323, rome, paris, 13:30, 14:40, [tue, wed, thu]).

path(fs619, rome, greece, 14:40, 16:30, [mon, wed, thu, fri]).

path(fs620, greece, rome, 11:00, 13:10, [mon, wed, thu, fri]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Adds an element to a list.
addtolist(X,L,[X|L]).


%% CASE 1: Next node is the destination
route(Origin, Destination, DeptTime, ArrTime, Day, [Flightno], Visited):-
        findPath(Flightno, Origin, Destination, Dept1, Arr1, Day),
        not(member(Destination,Visited)).
        

%% CASE 2: 
route(Origin, Destination, Dept_Time, Arr_Time, Day, [Flightno|Route], Visited):-
        findPath(Flightno,Origin,Transit, DeptTime, ArrTime, Day),
        not(member(Transit,Visited)),
        route(Transit, Destination, Dept1, Arr1, Day, Route, [Transit|Visited]).
	

%% To Check if a valid path exists in the same day
findPath(Flightno, Origin, Destination, DeptTime, ArrTime, Day):-
        path(Flightno, Origin, Destination, DeptTime, ArrTime, Days),
        member(Day,Days).

check_flight(Origin_City, Destination_City, Dept_Time, Arr_Time, Day, Route, List, [Origin_City]):-
    route(Origin_City, Destination_City, Dept_Time, Arr_Time, Day, Route, [Origin_City]).
	%%addtolist(Route,List,AllFlights),
	%%write(AllFlights).
    
%% Query Part
plan_route(Origin_City, Destination_City, Day, Route):- 
        check_flight(Origin_City, Destination_City, Dept_Time, Arr_Time, Day, Route, [], [Origin_City]).
        





