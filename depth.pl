
%Depth First Search - Depth first%
%Used textbook as a reference%


writelist([]) :- nl.
writelist([H|T]):-
	write(H), 
	write(' '),  
	writelist(T).

member(X,[X|_]).
member(X,[_|T]):-
	member(X,T).

%from textbook page fiftyfour%
empty_set([ ]).
member_set([State, Parent], [[State, Parent] | _]).
member_set(X, [_ | T]) :-
	member_set(X, T).

go(Start, Goal) :-
	empty_stack(Empty_open),
	stack([Start, nil], Empty_open, Open_stack),
	empty_set(Closed_set),
	path(Open_stack, Closed_set, Goal).

start :-
	write('Depth-first is called'),nl,
	go(state(e,e,e,e),state(w,w,w,w)).


initial(state(e, e, e, e)).

opp(e,w).
opp(w,e).

path(Open_stack,_,_) :-
	empty_stack(Open_stack),
	write('no solution found with these rules').

path(Open_stack,Closed_set,Goal) :-
	stack([State, Parent], _, Open_stack),
	State = Goal,
	write('A solution is found!'),
	nl,
	printsolution([State,Parent], Closed_set).

path(Open_stack, Closed_set, Goal) :-
	stack([State, Parent], 
		Rest_open_stack, Open_stack),
	get_children(State, Rest_open_stack, 
		Closed_set, Children),
	add_list_to_stack(Children, Rest_open_stack,
	 New_open_stack),
	union([[State, Parent]], 
		Closed_set, New_closed_set),
	path(New_open_stack, New_closed_set, Goal).

get_children(State, Rest_open_stack, 
	Closed_set, Children) :-
	bagof(Child, moves(State, 
		Rest_open_stack, Closed_set, Child), 
	Children);
	Children = [ ].

unsafe(state(X,Y,Y,_)) :- opp(X,Y).
unsafe(state(X,_,Y,Y)) :- opp(X,Y).


moves(State,Rest_open_stack,Closed_set,[Next,State]):-
	move(State,Next), 
	\+(unsafe(Next)),
	\+(member_stack([Next,_],Rest_open_stack)),
	\+(member_set([Next,_],Closed_set)).

move(state(X,X,G,C),state(Y,Y,G,C)) :-
	opp(X,Y), \+(unsafe(state(Y,Y,G,C))),
	writelist(['try farmer - wolf',Y,Y,G,C]).


move(state(X,W,X,C),state(Y,W,Y,C)) :-
	opp(X,Y), \+(unsafe(state(Y,W,Y,C))),
                 writelist(['The farmer - goat',Y,W,Y,C]). 

move(state(X,W,G,X), state(Y,W,G,Y)) :-
	opp(X,Y), \+(unsafe(state(Y,W,G,Y))),
	writelist(['try farmer - cabbage',Y,W,G,Y]).

move(state(X,W,G,C), state(Y,W,G,C)) :-
	opp(X,Y), \+(unsafe(state(Y,W,G,C))),
	writelist(['try farmer by self',Y,W,G,C]).

move(state(F,W,G,C), state(F,W,G,C)) :-
	writelist(['BACKTRACK at: ',F,W,G,C]),fail.


%from text book ADTs%
empty_stack([ ]).

stack(Top,Stack,[Top|Stack]).

member_stack([State,Parent],[[State,Parent]|_]).

member_stack(M,[_|T]) :-
	member_stack(M,T).

add_list_to_stack(List, Stack, Result) :-
	append(List, Stack, Result).

%printsolution from textbook%

printsolution([State, nil], _) :-write(State),nl.
printsolution([State, Parent], Closed_set) :-
	member_set([Parent, Grandparent], Closed_set),
	printsolution([Parent, Grandparent], Closed_set),
	write(State),
	nl.

%from textbook page fourtyone%
delete_if_in_set(_,[],[]).
delete_if_in_set(E,[E|T],T):-!.
delete_if_in_set(E,[H|T],[H|T_new]):-
	delete_if_in_set(E,T,T_new),!.

add_if_not_in_set(X, S, S) :-
	member(X, S),!.

add_if_not_in_set(X, S, [X | S]).

union([ ], S, S).
union([H | T], S, S_new) :-
	union(T, S, S2),
	add_if_not_in_set(H, S2, S_new),!.
