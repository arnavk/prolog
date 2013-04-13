
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ASSUMPTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
1. The "Best" Flight from one Destination to another is the direct flight if one exists on the day the user wants to travel, else the user must try to query for flight for another day.
2. If there is no direct flight then, the system will check for the shortest indirect flight.
3. "Shortest Indirect flight" : shortest total time is the sum of the flight travel time and the transit time between the connecting segments.
4. Predefined function, "member" is used to determine if the selected day falls list of days the flights are available on.
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FACTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path(ba58, singapore, london, 23, 10, 05, 20, [mon, wed, thu, sat]).

path(ba24, london, singapore, 10, 00, 16, 00, [mon, wed, thu, sat]).

path(ba4732, london,  edinburgh, 09, 40, 10, 50, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4735, london,  edinburgh, 11, 40, 12, 50, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4822, london,  edinburgh, 18, 40, 19, 50, [mon, tue, wed, thu, fri]).

path(ba4733,  edinburgh, london, 08, 30, 09, 40, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4736,  edinburgh, london, 13, 40, 14, 50, [mon, tue, wed, thu, fri, sat, sun]).
path(ba4833,  edinburgh, london, 19, 40, 20, 50, [mon, tue, wed, thu, fri, sun]).

path(ba614, london, greece, 09, 10, 12, 45,[mon, tue, wed, thu, fri, sat, sun]).
path(sr805, london, greece, 14, 45, 18, 20, [mon, tue, wed, thu, fri, sat, sun]).

path(ba613, greece, london, 09, 00, 11, 40, [mon, tue, wed, thu, fri, sat]).
path(sr806, greece, london, 16, 10, 18, 55, [mon, tue, wed, thu, fri, sun]).

path(ba510, london, paris, 08, 30, 10, 30,  [mon, tue, wed, thu, fri, sat, sun]).
path(az459, london, paris, 13, 10, 15, 10, [mon, tue, wed, thu, fri, sat, sun]).

path(ba511, paris, london, 09, 10, 10, 20, [mon, tue, wed, thu, fri, sat, sun]).
path(az460, paris, london, 12, 20, 13, 30, [mon, tue, wed, thu, fri, sat, sun]).

path(jp322, paris, rome, 11, 30, 12, 40, [tue, wed, thu]).

path(jp323, rome, paris, 13, 30, 14, 40, [tue, wed, thu]).

path(fs619, rome, greece, 14, 40, 16, 30, [mon, wed, thu, fri]).

path(fs620, greece, rome, 11, 00, 13, 10,[mon, wed, thu, fri]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

same(X,X).


%% Reverses a list
reverse([X|Y],Z,W) :- reverse(Y,[X|Z],W).
reverse([],X,X).

%% Adds an element to a list.
addtolist(X,L,[X|L]).


timediff(H1, M1, H2, M2, H, M):-

(
(M2>M1),(H2>H1)->(M is M2-M1), (H is H2-H1);
(M2>M1),(H2<H1)->(M is M2-M1), (H is 24+H2-H1);
(M2<M1),(H2>H1)->(M is 60+M2-M1), (H is H2-H1-1);
(M2<M1),(H2<H1)->(M is 60+M2-M1), (H is 24+H2-H1-1)
).

addtime(H1, M1, H2, M2, H, M):-
(
((M1+M2)<60)-> (M is M1+M2), (H is H1+H2);
((M1+M2)>60)-> (M is ((M1+M2)-60)), (H is H1+H2+1)
).

  
%% CASE 1: Next node is the destination
route(Origin, Destination, Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, Day, [Flightno], Visited, H1,[M|M1]):- findPath(Flightno, Origin, Destination, Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, Day, H1, M1), not(member(Destination,Visited)).
 
%% CASE 2: 
route(Origin, Destination, Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, Day, [Flightno|Route], Visited, [H|H1],[M|M1]):- 
findPath(Flightno, Origin, Transit, Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, Day, H1, M1), 
not(member(Transit,Visited)), 
route(Transit, Destination, Dept2_TimeH, Dept2_TimeM, Arr2_TimeH, Arr2_TimeM, Day, Route, [Transit|Visited], H, M).
 
%% To Check if a valid path exists in the same day
findPath(Flightno, Origin, Destination, Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, Day, H, M ):- path(Flightno, Origin, Destination, Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, Days), member(Day,Days), timediff(Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, H, M).

%% Query Part
plan_route(Origin_City, Destination_City, Day, Route, H1, M1):- route(Origin_City, Destination_City, Dept_TimeH, Dept_TimeM, Arr_TimeH, Arr_TimeM, Day, Route, [Origin_City], H1, M1).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INDIRECT FLIGHT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get all possible indirect flights to the given location.

find_transit_flight(Origin, FinalDestination, TraveledTo, FlightList, PossibleFlights, OldFlights) :-

        path(FlightNo, Origin, Destination, DepartTimeH, DepartTimeM, ArriveTimeH, ArriveTimeM, Days),
        addtolist(Origin, TraveledTo, Path),
        addtolist(FlightNo, FlightList, Route),
        not(member(Destination, Path)),
        not(Origin = FinalDestination),
        not(FinalDestination = Destination),
        
    find_transit_flight(Destination, FinalDestination, Path, Route, PossibleFlights1, OldFlights),
        PossibleFlights = PossibleFlights1

;
        
        Origin = FinalDestination,
        not(member(FlightList, TransitFlights)),
        addtolist(FlightList, TransitFlights, PossibleFlights),
        true.



find_indirect_flight(Origin, Destination, Day, Found, OldFlights, PossibleFlights):-

        find_transit_flight(Origin, Destination, [], [], PossibleFlights, OldFlights),
        OldFlights1 = PossibleFlights,
        find_indirect_flight(Origin, Destination, Day, Found, OldFlights1, PossibleFlights1).


%%find_shortest_flight([], 99999, OldFlights, Day).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DIRECT FLIGHT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

print_direct_flight(FlightNum, DepartTimeH, DepartTimeM, ArriveTimeH, ArriveTimeM, Day) :-
    timediff(DepartTimeH, DepartTimeM, ArriveTimeH, ArriveTimeM, TotalH, TotalM),
    write('     Direct Route->     '), nl, write('     Flight Number: '), write(FlightNum), write(' '), write('departs on '), write(Day),
    write(' at '), write(DepartTimeH),write(':'),write(DepartTimeM),
    write(' and arrives at '), write(ArriveTimeH), write(':'),write(ArriveTimeM), nl,
    write('     Total Flight time is '), write(TotalH),write(':'),write(TotalM), nl.


find_direct_flight(Origin, Destination, Day, Found) :-
        path(FlightNo, Origin, Destination, DepartTimeH, DepartTimeM, ArriveTimeH, ArriveTimeM, Days),
        member(Day,Days),
        %% If the direct flight was found!
        print_direct_flight(FlightNo, DepartTimeH, DepartTimeM, ArriveTimeH, ArriveTimeM, Day),
        Found = true

    ;
%% If direct_flight not found.
Found = false,fail.



%% main: "flight(Origin, Destination, Day)."

flight(Origin, Destination, Day) :-
%%CASE 1: Finding the direct flight...
        nl, write('Checking flights from '), write(Origin), write(' to '),write(Destination), write('!'), nl,nl,
        find_direct_flight(Origin, Destination, Day, FoundDirect),
        same(FoundDirect, true),
        nl, write('     Hope you have a pleasant journey!'), nl

    ;

%%Fail Part following the semi colon:
%%CASE 2: Finding the indirect flight since the direct flight wasnt found.

        find_indirect_flight(Origin, Destination, Day, FoundIndirect, [], PossibleFlights),
        %%Indirect flight found!! 
        nl, write('     Hope you have a pleasant journey!'), nl
    ;

%%Fail Part following the semi colon:
%%CASE 3: No flight was found!
        write('Sorry no flight available from '), write(Origin), write(' to '),write(Destination),nl,write('Please try your search for another day!'),false. 
