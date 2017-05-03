% Problem #1, "It's a Day", Dell Logic Puzzles, October 1999
% Each man (mr so-and-so) got a Day from a Object.
object(balloon).
object(clothesline).
object(frisbee).
object(water_tower).

person(msbarrada).
person(msgort).
person(mrklatu).
person(mrnikto).

day(tuesday).
day(wednesday).
day(thursday).
day(friday).

solve :-
    object(BarradasObject), object(GortsObject), object(KlatusObject), object(NiktosObject),
    all_different([BarradasObject, GortsObject, KlatusObject, NiktosObject]),
    
    person(MsBarrada), person(MsGort), person(MrKlatu), person(MrNikto),
    all_different([MsBarrada, MsGort, MrKlatu, MrNikto]),

    Triples = [ [MsBarrada, BarradasObject, tuesday],
                [MsGort, GortsObject, wednesday],
                [MrKlatu, KlatusObject, thursday],
                [MrNikto, NiktosObject, friday] ],

	% 1. Mr. Klatu made his sighting at some point earlier in the week than the
	%    one who saw the balloon, but at some point later in the week than the
	%    one who spotted the frisbee (who isn't Ms. Gort)
	\+ (member([mrklatu, balloon, _], Triples)),
	\+ (member([mrklatu, frisbee, _], Triples)),
	   before([mrklatu, _, _], [_, balloon, _], Triples),
	   before([_, frisbee, _], [mr_klatu, _, _], Triples),
    \+ (member([msgort, frisbee, _], Triples)),
	% 2. Friday's sighting was made by either Ms. Barrada or the one who saw
	%    a clothesline, or both
	(  member([msbarrada, _, friday], Triples) ; 
	   member([_, clothesline, friday], Triples)),

	% 3. Mr. Nikto did not make his sighting on Tuesday
	\+ (member([mrnikto, _, tuesday], Triples)),
   
    % 4. Mr. Klatu isn't the one whose object turned out to be a water tower
    \+ (member([mrklatu, water_tower, _], Triples)),
   
    tell(MsBarrada, BarradasObject, tuesday),
    tell(MsGort, GortsObject, wednesday),
    tell(MrKlatu, KlatusObject, thursday),
    tell(MrNikto, NiktosObject, friday).

% Succeeds if all elements of the argument list are bound and different.
% Fails if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

before(X, _, [X | _]).
before(_, Y, [Y | _]) :- !, fail.
before(X, Y, [_ | T]) :- before(X, Y, T). 

tell(X, Y, Z) :-
    write(X), write(' saw the '), write(Y), write(' on '), write(Z), 
    write('.'), nl.