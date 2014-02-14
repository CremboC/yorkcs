% an inefficient generate-and-test approach!
ok(Vertices,Edges) :-
	colouring(Vertices,Colours),
	ok_colouring(Edges,Colours).


colouring([],[]).
colouring([H|T],[H-Colour|T1]) :-
	colour(Colour),
	colouring(T,T1).

% add or remove colours here.
colour(red).
colour(green).


% each edge must have differently coloured vertices
ok_colouring([],_Colours).
ok_colouring([V1-V2|T],Colours) :-
	member(V1-Colour1,Colours),
	member(V2-Colour2,Colours),
	% "\+" just means "not"
	\+ Colour1 = Colour2,
	ok_colouring(T,Colours).



member(X,[X|_]).
member(X,[_|T]) :- member(X,T).
