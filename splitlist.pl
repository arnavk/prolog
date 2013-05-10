splitList([H|T]):- split_list([H|T], H, []).

split_list([], _, X):- printList(X), printList([]).
split_list([H|T], H, X) :- printList(X), printList( [H|T]), nl, append([H], X, Y).
split_list(T, _, Y).

printList([]):-write('[]').
printList(X):- write(X).

append([],X,X). % base
append([X|Y],Z,[X|W]) :- append(Y,Z,W). %recursive