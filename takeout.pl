takeout(A,[A|B],B).
takeout(A,[B|C],[B|D]) :-
          takeout(A,C,D).
