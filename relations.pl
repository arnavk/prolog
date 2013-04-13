father(X,Y) :- parent_of(X,Y), male(X).
mother(X,Y) :- parent_of(X,Y), female(X).
son(X,Y) :- parent_of(Y,X), male(X).
daughter(X,Y) :- parent_of(Y,X), female(X).
grandfather(X,Y) :- parent_of(X,Z), parent_of(Z,Y), male(X).
sibling(X,Y) :- (parent_of(Z,X), parent_of(Z,Y), male(Z), X\=Y);(brother(X,Y);sister(X,Y)).
aunt(X,Y) :- sibling(X,Z), female(X), parent_of(Z,Y).
uncle(X,Y) :- sibling(X,Z), male(X), parent_of(Z,Y).
cousin(X,Y):- sibling(W,Z), parent_of(W,X), parent_of(Z,Y).
spouse(X,Y) :-  parent_of(X,Z), parent_of(Y,Z), X\=Y.