last_item([Item],Item).
last_item([_|Tail], Item):-
	last_item(Tail, Item).

maxInList([Max],Max).
maxInList([H|Tail], Max):-
	maxInList(Tail, TailMax),
	max(H, TailMax, Max).


max(X,Y,X):- X>=Y, !.
max(X,Y,Y):- Y>X.


printList([]).
printList([Head|List]):-
	printList(List),
	write(Head), nl.

readInput(0,[Head|List]):-
	printList(List).

readInput(H, List):-
	read(X),
	integer(X),
	readInput(X, [X|List]).


wholePrice(Price, WholeSalePrice):-
	100>=Price,
	WholeSalePrice is (Price*1.2).
wholePrice(Price, WholeSalePrice):-
	Price>100, 1000>=Price,
	WholeSalePrice is (Price*1.15).
wholePrice(Price, WholeSalePrice):-
	Price>1000,
	WholeSalePrice is (Price*1.1).

generator(station).
transformer(t1).
transformer(t2).
transformer(t3).
transformer(t4).
transformer(t5).
transformer(t6).
consumer(c1).
consumer(c2).
consumer(c3).
consumer(c4).
consumer(c5).
consumer(c6).
consumer(c7).
consumer(c8).
consumer(c9).
consumer(c10).

feeds(station, t1).
feeds(station, t2).
feeds(station, t3).
feeds(t1, t4).
feeds(t1, t5).
feeds(t3, t6).
feeds(t4, c1).
feeds(t4, c2).
feeds(t4, c3).
feeds(t5, c4).
feeds(t5, c5).
feeds(t2, c6).
feeds(t2, c7).
feeds(t6, c8).
feeds(t6, c9).
feeds(t3, c10).


supplies(X,Y):-feeds(X,Y).
supplies(X,Y):-feeds(X,Z), supplies(Z,Y).

affectedBy(X, Y):-supplies(X,Y), consumer(Y).