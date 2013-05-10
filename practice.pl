app([], List, List).
app([H|T], List, [H|L2]):- app(T, List, L2).

splitList(R):- app(L1, L2, R), write(L1), write(L2), nl, fail.

prefix(L1, L2):- app(L1, _, L2).

app2(L, [], L).
app2(L1, [H|T2], [H|L3]):- app2(L1, T2, L3).

printList([]).
printList([H|T]):-write(H), write(' '), printList(T).

reversePrint([X]):- write(X).
reversePrint([H|T]):-reversePrint(T), write(','), write(H).

reverseList([], Result, Result).
reverseList([H|T1], T2, X):- reverseList(T1, [H|T2], X).

splitList2(List):-
	reverseList(List, [], Rev),
	popper(Rev, []).


popper([], X):- write('[]'), write(X),nl.
popper([H|List1], List2):-
	popper(List1, [H|List2]),
	write('['), reversePrint([H|List1]), write(']'), write(List2), nl.


del(_, [], []).
del(X, [X|T], T2):-del(X, T, T2).
del(X, [H|T1], [H|T2]):- H\=X, del(X, T1, T2).

del2(X, [X|T], T).
del2(X, [H|T1], [H|T2]):-del2(X, T1, T2).

run_foo(X, InList, OutList):- del2(X, InList, OutList), write(OutList), nl, fail.

odd_sum([H|T], Sum, Index, R):- IsOdd is mod(Index, 2), IsOdd = 1, !, NewSum is (H + Sum), odd_sum(T, NewSum, Index+1, R).
odd_sum([_|T], Sum, Index, R):- IsOdd is mod(Index, 2), IsOdd = 0, odd_sum(T, Sum, Index+1, R).
odd_sum([], Sum, _, Sum).

sum_odd([], 0).
sum_odd([X], X).
sum_odd([X,_|T], Sum):- sum_odd(T, Sum1), Sum is Sum1+X.

sum_even([], 0).
sum_even([_], 0).
sum_even([_,X|T], Sum):- sum_even(T, Sum1), Sum is Sum1+X.

helper(_, [], []).
helper(X, [H|T1], [H|T2]):- H>X, helper(X, T1, T2).
helper(X, [H|T1], T2):- X>=H, helper(X, T1, T2).

member(X,[X|T]).
member(X,[H|T]):-member(X,T).

removeDuplicate([], _, []).
removeDuplicate([H|T1], List, [H|R]):-not(member(H, List)),removeDuplicate(T1,List,R).
removeDuplicate([H|T1], List, R):-member(H, List),removeDuplicate(T1,List,R).